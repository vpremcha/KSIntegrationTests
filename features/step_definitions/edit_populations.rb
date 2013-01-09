#When /^I update all the editable fields of a (.*) population$/ do |type|
#  @population = make Population, :type=>type
#  @population.create
#end

When /^I update all the editable fields of the population$/ do
  things = {
  :name=>random_alphanums.strip,
  :description=>random_alphanums_plus.strip, # TODO: change to multiline when line feed issue is addressed
  :status=>"inactive"
  }
  things.store(:rule, "random") if @population.type == "rule-based"
  things.store(:reference_population, "random") if @population.type == "exclusion-based"
  things.store(:child_populations, %w{random random}) unless @population.type == "rule-based"
  @population.edit_population things
end

When /^I edit the (.*) of the population$/ do |attrib|
  things = {
  :name=>{:name=>random_alphanums.strip},
  :description=>{:description=>random_multiline(20,5)},
  :rule=>{:rule=>"random"},
  :"reference population"=>{:reference_population=>"random"},
  :"child populations"=>{:child_populations=>%w{random random}}
  }
  option = things[attrib.to_sym]
  @population.edit_population option
end

When /^I set the status of the population to "(.*)"/ do |status|
  @population.edit_population(:status=>status.downcase)
end

When /^I rename a population with an existing name$/ do
  @population = make Population
  @population.create
  @original_name = @population.name

  @population2 = make Population
  @population2.create

  @population.edit_population :name=>@population2.name
end

Then /^the population name is not changed$/ do
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set @original_name
    page.search
    page.results_list.length.should == page.results_list.uniq.length
  end
end

Then /^a read-only view of the updated population is displayed$/ do
  on ViewPopulation do |page|
    page.name.should == @population.name
    page.description.strip.should == @population.description.strip
    page.rule.should == @population.rule unless @population.rule == nil
    page.state.downcase.should == @population.status
    page.operation.downcase.should == @population.operation unless @population.operation == nil
    page.reference_population.should == @population.reference_population unless @reference_population == nil
    page.child_populations.sort.should == @population.child_populations.sort unless @population.type == "rule-based"
  end
end

When /^I am editing a (.*) population$/ do |type|
  @population = make Population, :type=>type
  @population.create
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set @population.name
    page.search
    page.edit @population.name
  end
end

Then /^the population operation type is read-only$/ do
  on EditPopulation do |page|
    page.operation_element.should exist
  end
end

