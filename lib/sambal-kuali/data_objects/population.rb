class Population

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include PopulationsSearch

  attr_accessor :name, :description, :rule, :operation, :child_populations,
                :reference_population, :status, :type

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums.strip,
        :description=>random_alphanums_plus.strip, # TODO: figure out why random_multiline does not validate properly
        :type=>"rule-based",
        :child_populations=>[],
        :rule=>nil,
        :reference_population=>nil,
        :status=>"Active"
    }
    options = defaults.merge(opts)

    set_options(options)
    operations = {:"union-based"=>"union",:"intersection-based"=>"intersection",:"exclusion-based"=>"exclusion"}
    @operation = operations[type.to_sym]
  end

  def create
    go_to_create_population
    on CreatePopulation do |page|
      page.name.set @name
      page.description.set @description
      page.by_using_populations unless @type == 'rule-based'
      case(@type)
        when 'rule-based'
          # Select a random rule if none is defined
          @rule=random_rule(page) if @rule == nil
          page.rule.select @rule
        when 'union-based'
          # Select union...
          page.union
        when 'intersection-based'
          # Select intersection...
          page.intersection
        when 'exclusion-based'
          # Select exclusion...
          page.exclusion
          @reference_population == nil ? @reference_population = add_random_ref_pop : add_ref_pop(@reference_population) unless @reference_population == " "
        else
          raise "Your population type value must be one of the following:\n'rule-based', 'union-based', 'intersection-based', or 'exclusion-based'.\nPlease update your script"
      end
      unless type=='rule-based'
        if @child_populations.length == 0
          2.times { @child_populations << add_random_population }
        else
          @child_populations.each do |pop|
            if pop == "random"
              pop.replace(add_random_population)
            else
              add_child_population(pop)
            end
          end
        end
      end
    end
    on CreatePopulation do |page|
      # Click the create population button...
      page.create
    end
    sleep 10
  end

  def edit_population opts={}

    defaults = {
        :name=>@name,
        :description=>@description,
        :status=>@status,
        :rule=>@rule,
        :reference_population=>@reference_population,
        :child_populations=>@child_populations
    }
    options=defaults.merge(opts)

    go_to_manage_population
    on ManagePopulations do |page|
      page.keyword.set @name
      page.both.set
      page.search
      page.edit @name
    end
    on EditPopulation do |page|
      page.name.set options[:name]
      page.description.set options[:description]
      page.send(options[:status].downcase).set
      if options[:rule] == "random"
        options[:rule]=new_random_rule(page)
      end
      page.rule.select(options[:rule]) unless options[:rule] == nil

      if options[:reference_population] == "random"
        options[:reference_population] = update_random_ref_pop
        @reference_population = options[:reference_population] #updating instance variable immediately - don't want to reuse this pop
      else
        update_ref_pop(options[:reference_population]) unless options[:reference_population] == @reference_population or options[:reference_population]  == nil
      end

      unless @child_populations == options[:child_populations] or options[:child_populations] == []
        page.child_populations.reverse.each { |pop| page.remove_population(pop) }
        @child_populations = options[:child_populations] #updating instance variable immediately - don't want to reuse this pop
        @child_populations.each do |pop|
          if pop == "random"
            pop.replace(add_random_population)
          else
            add_child_population(pop)
          end
        end
        options[:child_populations] = @child_populations #keep in sync
      end

      page.update

      if page.first_msg == "Document was successfully submitted."
        set_options(options)
      else
        # Do not update the Population attributes.
      end
    end
  end

  def add_child_population(child_population)
    on CreatePopulation do |page|
      page.lookup_population
    end
    on ActivePopulationLookup do |page|
      page.keyword.wait_until_present
      page.keyword.set child_population
      page.search
      page.return_value child_population
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.child_population.value == child_population }
      page.add
    end
  end

  def add_random_population
    on CreatePopulation do |page|
      page.lookup_population
    end
    population = search_for_random_pop(@child_populations.to_a + [@reference_population.to_s] )
    on ActivePopulationLookup do |page|
      page.return_value population
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.child_population.value == population }
      page.add
    end
    population
  end

  def add_ref_pop(population)
    on CreatePopulation do |page|
      page.lookup_ref_population
    end
    on ActivePopulationLookup do |page|
      page.keyword.wait_until_present
      page.keyword.set population
      page.search
      page.return_value population
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.reference_population.value == population }
    end
  end

  def add_random_ref_pop
    on CreatePopulation do |page|
      page.lookup_ref_population
    end
    population = search_for_random_pop(@child_populations.to_a + [@reference_population.to_s])
    on ActivePopulationLookup do |page|
      page.return_value population
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.reference_population.value == population }
    end
    population
  end

  def update_ref_pop(pop)
    on EditPopulation do |page|
      page.lookup_ref_population
    end
    pop = search_for_random_pop(@child_populations.to_a + [@reference_population.to_s])
    on ActivePopulationLookup do |page|
      page.return_value pop
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.reference_population.value == pop }
    end
  end

  def update_random_ref_pop
    pop = ""
    on EditPopulation do |page|
      page.lookup_ref_population
    end
    pop = search_for_random_pop(@child_populations.to_a + [@reference_population.to_s])
    on ActivePopulationLookup do |page|
      page.return_value pop
    end
    on CreatePopulation do |page|
      page.wait_until(30) { page.reference_population.value == pop }
    end
    pop
  end

  # Returns (as a string) one of the rules listed in the Rule selection list.
  def random_rule(page)
    rules = []
    page.rule.options.to_a.each { |item| rules << item.text }
    rules.delete(@rule) unless @rule == nil
    rules.shuffle!
    rules[0]
  end

  def new_random_rule(page)
    new_rule = random_rule(page)
    if new_rule == @rule
      new_random_rule(page)
    else
      new_rule
    end
  end

end