class HolidayCalendar

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :name, :start_date, :end_date, :organization, :holiday_types

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums.strip,
        :start_date=>"09/01/#{next_year[:year]}",
        :end_date=>"06/25/#{next_year[:year] + 1}",
        :organization=>"Registrar's Office",
        :holiday_types=>[
            {:type=>"random", :start_date=>"02/01/#{next_year[:year] + 1}", :all_day=>true, :date_range=>false, :instructional=>false},
            {:type=>"random", :start_date=>"03/02/#{next_year[:year] + 1}", :end_date=>"03/04/#{next_year[:year] + 1}", :all_day=>true, :date_range=>true, :instructional=>false},
            {:type=>"random", :start_date=>"04/05/#{next_year[:year] + 1}", :start_time=>"03:00", :start_meridian=>"pm", :end_time=>"07:44", :end_meridian=>"pm", :all_day=>false, :date_range=>false, :instructional=>false},
            {:type=>"random", :start_date=>"05/11/#{next_year[:year] + 1}", :start_time=>"02:22", :start_meridian=>"am", :end_date=>"05/22/#{next_year[:year] + 1}", :end_time=>"07:44", :end_meridian=>"pm", :all_day=>false, :date_range=>true, :instructional=>false}
        ]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def create
    go_to_holiday_calendar
    on CopyHolidayCalendar do |page|
      page.start_blank_calendar
    end
    on CreateHolidayCalendar do |page|
      page.name.set @name
      page.start_date.set @start_date
      page.end_date.set @end_date
      page.organization.select @organization
      @holiday_types.each do |holiday|
        if holiday[:type] == "random"
          page.select_random_holiday
          holiday[:type]=page.holiday_type.value
        else
          page.holiday_type.select holiday[:type]
        end
        page.holiday_start_date.set holiday[:start_date]
        if holiday[:date_range]
          page.date_range.set
          begin
            wait_until { holiday_end_date.enabled? }
          rescue Selenium::WebDriver::Error::StaleElementReferenceError
            sleep 2
          end
          page.holiday_end_date.set holiday[:end_date]
        else
          page.date_range.clear if page.date_range.set?
        end
        if holiday[:all_day]
          all_day.set unless all_day.set?
        else
          page.start_time
        end
      end
    end
  end

  def copy_from(name)
    go_to_holiday_calendar
    if right_source? name
      on CopyHolidayCalendar do |page|
        page.name.set @name
        page.start_date.set @start_date
        page.end_date.set @end_date
      end
    else
      on CopyHolidayCalendar do |page|
        page.choose_different_calendar
      end
      on CalendarSearch do |page|
        page.search_for "Holiday Calendar", name
        page.copy name
      end
      on EditAcademicCalendar do |page|
        page.academic_calendar_name.set @name
        page.organization.select @organization
        page.calendar_start_date.set @start_date
        page.calendar_end_date.set @end_date
      end
      on EditAcademicCalendar do |page|
        page.save
      end

      def search
        go_to_calendar_search
        on CalendarSearch do |page|
          page.search_for "Academic Calendar", @name
        end
      end

      def right_source?(name)
        on CreateAcadCalendar do |page|
          if page.source_name == name
            return true
          else
            return false
          end
        end
      end

      def make_official
        on EditAcademicCalendar do |page|
          page.make_official
        end
      end

    end
  end
end

