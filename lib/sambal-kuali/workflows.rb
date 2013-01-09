# Helper methods that don't properly belong elsewhere. This is
# a sort of "catch all" Module.
module Workflows

  # Site Navigation helpers...
  def go_to_rollover_details
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.view_rollover_details
    end
  end


  def go_to_perform_rollover
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.perform_rollover
    end
  end

  def go_to_create_population
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.manage_populations
    end
    on ManagePopulations do |page|
      page.create_new
    end
  end

  def go_to_manage_population
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.manage_populations
    end
  end

  def go_to_manage_reg_windows
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.manage_registration_windows
    end
  end

  def go_to_manage_course_offerings
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.manage_course_offerings
    end
  end

  def go_to_display_schedule_of_classes
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.schedule_of_classes
    end

  end

  def go_to_holiday_calendar
    visit MainMenu do |page|
      page.enrollment
    end
    on Enrollment do |page|
      page.create_holiday_calendar
    end
  end


  def go_to_academic_calendar
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.create_academic_calendar
    end
  end

  def go_to_calendar_search
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.search_for_calendar_or_term
    end
  end

  def go_to_create_course_offerings
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.create_course_offerings
    end
  end
  # Helper methods...

  def go_to_manage_soc
    visit MainMenu do |page|
      page.enrollment_home
    end
    on Enrollment do |page|
      page.manage_soc
    end
  end

  def logged_in_user
    user = ""
    on Header do |page|
      begin
        user = page.logged_in_user
      rescue Watir::Exception::UnknownObjectException
        user = "No One"
      end
    end
    user
  end

  def log_in(user, pwd)
    on Login do |page|
      page.login_with user, pwd
    end
  end

end