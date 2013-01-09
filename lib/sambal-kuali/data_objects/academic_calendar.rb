class AcademicCalendar

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :name, :start_date, :end_date, :organization, :events,
                :holidays, :terms

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums.strip,
        :start_date=>"09/01/#{next_year[:year]}",
        :end_date=>"06/25/#{next_year[:year] + 1}",
        :organization=>"Registrar's Office"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def create
    go_to_academic_calendar
    on CreateAcadCalendar do |page|
      page.start_blank_calendar
    end
    on EditAcademicCalendar do |page|
      page.academic_calendar_name.set @name
      page.organization.select @organization
      page.calendar_start_date.set @start_date
      page.calendar_end_date.set @end_date
      page.save
    end
  end

  def copy_from(name)
    go_to_academic_calendar
    if right_source? name
      on CreateAcadCalendar do |page|
        page.name.set @name
        page.start_date.set @start_date
        page.end_date.set @end_date
      end
    else
      on CreateAcadCalendar do |page|
        page.choose_different_calendar
      end
      on CalendarSearch do |page|
        page.search_for "Academic Calendar", name
        page.copy name
      end
      on EditAcademicCalendar do |page|
        page.academic_calendar_name.set @name
        page.organization.select @organization
        page.calendar_start_date.set @start_date
        page.calendar_end_date.set @end_date
      end
    end
    on EditAcademicCalendar do |page|
      page.save
    end
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