  class ActivityOffering
    include Foundry
    include DataFactory
    include DateFactory
    include StringFactory
    include Workflows

    attr_accessor :code,
                  :format,
                  :activity_type,
                  :max_enrollment,
                  :actual_delivery_logistics_list,
                  :requested_delivery_logistics_list,
                  :personnel_list,
                  :seat_pool_list,
                  :seat_remaining_percent,
                  :course_url,
                  :evaluation,
                  :honors_course

    def initialize(browser, code)
      @browser = browser
      @seat_pool_list = {}
      @actual_delivery_logistics_list = {}
      @requested_delivery_logistics_list = {}

    end

    def create(opts = {})

      default_seat_pool_hash = {"random"=> (make SeatPool)}
      default_rdl_hash = {"default"=> (make DeliveryLogistics)}

      defaults = {
          :format => "Lecture",
          :activity_type => "Lecture",
          :max_enrollment => 100,
          :actual_delivery_logistics_list => {},
          :requested_delivery_logistics_list => default_rdl_hash,
          :personnel_list => Array.new(1){make Personnel} ,
          :seat_pool_list => default_seat_pool_hash,
          #:seat_pool_list => Array.new(1){make SeatPool},
          :course_url => "www.test_course.com",
          :evaluation => true,
          :honors_course => true
      }
      options = defaults.merge(opts)

      @format = options[:format]
      @activity_type = options[:activity_type]

      on ManageCourseOfferings do |page|
        pre_add_ao_list = page.codes_list
        post_add_ao_list = []
        #if page.codes_list.length == 0
        sleep 2
        page.format.select @format
        page.loading.wait_while_present
        sleep 2
        page.activity_type.select @activity_type
        page.quantity.set "1"
        page.add
        post_add_ao_list = page.codes_list
        #end
        new_code =  post_add_ao_list - pre_add_ao_list
        @code = new_code[0]
      end

      on ManageCourseOfferings do |page|
        page.edit @code
      end

      edit(options)
    end


    def edit opts={}

      defaults = {
          :max_enrollment => @max_enrollment,
          :actual_delivery_logistics_list => @actual_delivery_logistics_list,
          :requested_delivery_logistics_list => @requested_delivery_logistics_list,
          :personnel_list => @personnel_list ,
          :seat_pool_list => @seat_pool_list,
          :course_url => @course_url,
          :evaluation => @evaluation,
          :honors_course => @honors_course
      }

      options=defaults.merge(opts)

      if options[:max_enrollment] != @max_enrollment
        on ActivityOfferingMaintenance do |page|
          page.total_maximum_enrollment.set options[:max_enrollment]
          page.total_maximum_enrollment.fire_event "onchange"
          @max_enrollment = options[:max_enrollment]
        end
      end

      #TODO: comparison could be more robust
      if options[:requested_delivery_logistics_list].keys != @requested_delivery_logistics_list.keys
        if options[:requested_delivery_logistics_list].length > 0
          on ActivityOfferingMaintenance do |page|
            page.revise_logistics
          end
          #'save' vs 'save and process' determined by first rdl
          first_rdl = options[:requested_delivery_logistics_list].values[0]
          #list of requests added with updated keys
          requests_added = {}

          options[:requested_delivery_logistics_list].values.each do |request|
            request.add_logistics_request()
            requests_added["#{request.days}#{request.start_time}#{request.start_time_ampm.upcase}".delete(' ')] = request
          end

          if first_rdl.process
            @actual_delivery_logistics_list.merge!(requests_added)
            first_rdl.save_and_process()
          else
            @requested_delivery_logistics_list.merge(requests_added)
            first_rdl.save()
          end
        end
      end

      on ActivityOfferingMaintenance do |page|
        if options[:course_url] != @course_url
          page.course_url.set options[:course_url]
          @course_url = options[:course_url]
        end

        if options[:evaluation] != @evaluation
          if options[:evaluation]
            page.requires_evaluation.set
          else
            page.requires_evaluation.clear
          end
          @evaluation =  options[:evaluation]
        end

        if options[:honors_course] != @honors_course
          if options[:honors_course]
            page.honors_flag.set
          else
            page.honors_flag.clear
          end
          @honors_course = options[:honors_course]
        end
      end
      if options[:personnel_list] != @personnel_list
        options[:personnel_list].each do |person|
          person.add_personnel
        end
        @personnel_list = options[:personnel_list]
      end

      #TODO: comparison could be more robust
      if options[:seat_pool_list].keys != @seat_pool_list.keys
        options[:seat_pool_list].each do |key,seat_pool|
          seat_pool.add_seatpool(seatpool_populations_used)
          @seat_pool_list[key] = seat_pool unless !seat_pool.exp_add_succeed?
        end
      end
    end

    def update()
      on ActivityOfferingMaintenance do |page|
        page.submit
      end
    end

    def save()
      on ActivityOfferingMaintenance do |page|
        page.submit
      end
    end

    def seats_remaining
      seats_used = 0
      @seat_pool_list.each do |key,seat_pool|
        seats_used += seat_pool.seats.to_i
      end
      [@max_enrollment - seats_used , 0].max
    end

    def remove_seatpool(seatpool_key)
      on ActivityOfferingMaintenance do |page|
        page.remove_seatpool(@seat_pool_list[seatpool_key].population_name)
      end
      @seat_pool_list.delete(seatpool_key)
    end

    def remove_seatpools()
      @seat_pool_list.each do |seatpool_key|
        if @seat_pool_list[seatpool_key].remove
          on ActivityOfferingMaintenance do |page|
            page.remove_seatpool(@seat_pool_list[seatpool_key].population_name)
          end
          @seat_pool_list.delete(seatpool_key)
        end
      end
    end

    def resequence_seatpools()
      @seat_pool_list.values.each do |seatpool|
        seatpool.priority = seatpool.priority_after_reseq
      end
    end

    def edit_seatpool opts = {}

      sp_key = opts[:seatpool_key]
      sp_key = @seat_pool_list.keys[0] unless sp_key != nil

      defaults = {
          :priority => @seat_pool_list[sp_key].priority,
          :seats => @seat_pool_list[sp_key].seats,
          :expiration_milestone => @seat_pool_list[sp_key].expiration_milestone,
          :remove => false,
          :priority_after_reseq => @seat_pool_list[sp_key].priority_after_reseq
      }
      options=defaults.merge(opts)
      update_pop_name = @seat_pool_list[sp_key].population_name

      on ActivityOfferingMaintenance do |page|
        page.update_seats(update_pop_name, options[:seats])
        @seat_pool_list[sp_key].seats = options[:seats]
      end

      if options[:priority] != @seat_pool_list[sp_key].priority
        on ActivityOfferingMaintenance do |page|
          page.update_priority(update_pop_name,options[:priority])
          @seat_pool_list[sp_key].priority = options[:priority]
        end
      end

      if options[:expiration_milestone] != @seat_pool_list[sp_key].expiration_milestone
        on ActivityOfferingMaintenance do |page|
          page.update_expiration_milestone(update_pop_name,options[:expiration_milestone])
          @seat_pool_list[sp_key].expiration_milestone = options[:expiration_milestone]
        end
      end

      if options[:priority_after_reseq] != @seat_pool_list[sp_key].priority_after_reseq
        @seat_pool_list[sp_key].priority_after_reseq = options[:priority_after_reseq]
      end

      #remove has to be last...
      if options[:remove]
        on ActivityOfferingMaintenance do |page|
          page.remove_seatpool(update_pop_name)
          @seat_pool_list.delete(sp_key)
        end
      end
    end

    def seatpool_populations_used
      populations_used = []
      @seat_pool_list.values.each do |seatpool|
        populations_used << seatpool.population_name
      end
      populations_used
    end

  end



  class SeatPool

    include Foundry
    include DataFactory
    include DateFactory
    include StringFactory
    include Workflows
    include PopulationsSearch

    attr_accessor :priority,
                  :seats,
                  :population_name,
                  :expiration_milestone,
                  :remove,
                  :priority_after_reseq,
                  :exp_add_succeed

    alias_method :remove?, :remove
    alias_method :exp_add_succeed?, :exp_add_succeed

    def initialize(browser, opts={})
      @browser = browser

      defaults = {
          :priority => 1,
          :seats => 10,
          :population_name => "random",
          :expiration_milestone => "First Day of Classes",
          :remove => false,
          :priority_after_reseq => 0,
          :exp_add_succeed => true
      }
      options = defaults.merge(opts)
      options[:priority_after_reseq] = options[:priority] unless options[:priority_after_reseq] != 0
      set_options(options)

    end

    def percent_of_total(max_enrollment)
      "#{(@seats.to_i*100/max_enrollment.to_i).round(0)}%"
    end

    def add_seatpool(pops_used_list)
      on ActivityOfferingMaintenance do |page|
        page.add_pool_priority.set @priority
        page.add_pool_seats.set @seats
        if @population_name != ""
          page.lookup_population_name

          #TODO should really call Population.search_for_pop
          on ActivePopulationLookup do |page|
            if @population_name == "random"
              page.keyword.wait_until_present
              #page.keyword.set random_letters(1)
              page.search
              #page.change_results_page(1+rand(3))
              #names = page.results_list
              #@population_name = names[1+rand(9)]
              @population_name = search_for_random_pop(pops_used_list)
              page.return_value @population_name
            else
              page.keyword.set @population_name
              page.search
              page.return_value @population_name
            end
          end

        end
        on ActivityOfferingMaintenance do |page|
          page.add_seat_pool
        end
      end
    end
  end

  class Personnel
    include Foundry
    include DataFactory
    include DateFactory
    include StringFactory
    include Workflows

    attr_accessor :id,
                  :affiliation,
                  :inst_effort

    def initialize(browser, opts={})
      @browser = browser

      defaults = {
          :id => "admin",
          :affiliation => "Instructor",
          :inst_effort => 50
      }
      options = defaults.merge(opts)
      set_options(options)
    end

    def add_personnel
      on ActivityOfferingMaintenance do |page|
        page.add_person_id.set @id
        page.add_affiliation.select @affiliation
        page.add_inst_effort.set @inst_effort
        page.add_personnel
      end
    end
  end

  class DeliveryLogistics
    include Foundry
    include DataFactory
    include DateFactory
    include StringFactory
    include Workflows

    attr_accessor :tba, #boolean
                  :days,
                  :start_time,
                  :start_time_ampm,
                  :end_time,
                  :end_time_ampm,
                  :facility,
                  :facility_long_name,
                  :room,
                  :features_list,
                  :process

    alias_method :tba?, :tba
    alias_method :process?, :process

    def initialize(browser, opts={})
      @browser = browser

      defaults = {
          :tba  => false,
          :days  => "MWF",
          :start_time  => "01:00",
          :start_time_ampm  => "pm",
          :end_time  => "02:00",
          :end_time_ampm  => "pm",
          :facility  => "ARM",
          :facility_long_name  => "Reckord Armory",
          :room  => "126",
          :features_list  => [],
          :process => true
      }
      options = defaults.merge(opts)
      set_options(options)
    end

    def add_logistics_request
      on DeliveryLogisticsEdit do |page|
        if @tba
          page.add_tba.set
        else
          page.add_tba.clear
        end

        page.add_days.set @days
        page.add_start_time.set @start_time
        page.add_start_time_ampm.select @start_time_ampm
        page.add_end_time.set @end_time
        page.add_end_time_ampm.select @end_time_ampm
        page.add_facility.set @facility
        page.add_room.set @room
        #page.facility_features TODO: later, facility features persistence not implemented yet
        page.add
      end

    end

    def save_and_process
      on DeliveryLogisticsEdit do |page|
        page.save_and_process_request
      end
    end

    def save
      on DeliveryLogisticsEdit do |page|
        page.save
      end
    end
  end