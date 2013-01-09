class ScheduleOfClasses

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :term,
                :course_search_parm,
                :keyword,
                :instructor_principal_name,
                :instructor_long_name,
                :department_short_name,
                :type_of_search,
                :exp_course_list #TODO: exp results can be expanded to include AO info, etc.

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"Spring 2012",
        :course_search_parm=>"ENGL103",
        :department_short_name=>"ENGL",
        :instructor_principal_name=>"B.JOHND",
        :keyword=>"WRITING FROM SOURCES" ,
        :type_of_search=>"Course",    #Course, Department, Instructor, Title & Description
        :exp_course_list=>["ENGL103"]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def display
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      page.select_type_of_search(@type_of_search)
      case @type_of_search
        when "Course" then page.course_search_parm.set @course_search_parm
        when "Instructor" then instructor_lookup(@instructor_principal_name)
        when "Department" then department_lookup(@department_short_name)
        when "Title & Description" then page.title_description_search_parm.set @keyword
        else raise "ScheduleOfClasses - search type not recognized"
      end

      page.show
    end
  end

  def department_lookup(short_name)
    on  DisplayScheduleOfClasses do |page|
      page.department_search_lookup
    end
    on DepartmentLookup do |page|
      page.short_name.set(short_name)
      page.search
      page.return_value(short_name)
    end
  end

  def instructor_lookup(principal_name)
    on  DisplayScheduleOfClasses do |page|
      page.instructor_search_lookup
    end
    on PersonnelLookup do |page|
      page.principal_name.set(principal_name)
      page.search
      @instructor_long_name = page.get_long_name(principal_name)
      page.return_value(principal_name)
    end
  end

  def check_results_for_subject_code_match(subject_code)
    on DisplayScheduleOfClasses do |page|
      page.get_results_course_list.each do |course_code|
        raise "correct subject prefix not found for #{course_code}" unless course_code.match /^#{subject_code}/
      end
    end
  end

  def check_expected_results
    on DisplayScheduleOfClasses do |page|
      @exp_course_list.each do |course_code|
        raise "correct course not found" unless page.target_course_row(course_code).exists?
      end
    end
  end

  def expand_course_details
    on DisplayScheduleOfClasses do |page|
      page.course_expand(@exp_course_list[0])
      raise "error expanding course details for #{@exp_course_list[0]}"  unless page.course_ao_information_table(@exp_course_list[0]).exists?
    end
  end

  def expand_all_course_details
    on DisplayScheduleOfClasses do |page|
      list_of_courses = page.get_results_course_list()
      page.get_results_course_list().each do |course|
        page.course_expand(course)
        if !page.course_ao_information_table(course).exists?
          puts "error expanding course details for #{course}"
          #need to re-login after stacktrace
          log_in "admin", "admin"
          go_to_display_schedule_of_classes
          display
        else
          page.course_expand(course) #collapses
        end
      end
    end
  end


  def check_results_for_instructor
    course_list = []
    on DisplayScheduleOfClasses do |page|
      course_list = page.get_results_course_list
      course_list.each do |course_code|
        page.course_expand(course_code)
        raise "error expanding course details for #{course_code}"  unless page.course_ao_information_table(course_code).exists?
        instructor_list = page.get_instructor_list(course_code)
        raise "data validation issues: instructor #{@instructor_long_name} not found for course: #{course_code}" unless  instructor_list.include?(@instructor_long_name)
        page.course_expand(course_code) #closes details
      end
    end
  end

  end

