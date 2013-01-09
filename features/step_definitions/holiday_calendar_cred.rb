When /^I create a Holiday Calendar$/ do
  @calendar_name = random_alphanums
  @start_date = "09/01/#{next_year}"
  @end_date = "06/20/#{next_year + 1}"
  visit MainMenu do |page|
    page.enrollment_home
  end
  on Enrollment do |page|
    page.create_holiday_calendar
  end
  on CopyHolidayCalendar do |page|
    page.start_blank_calendar
  end
  on CreateHolidayCalendar do |page|
    page.calendar_name.set @calendar_name
    page.start_date.set @start_date
    page.end_date.set @end_date
    page.add_all_day_holiday(page.select_random_holiday, "02/01/#{next_year + 1}")
    page.add_date_range_holiday(page.select_random_holiday, "03/02/#{next_year + 1}", "03/04/#{next_year + 1}")
    page.add_partial_day_holiday(page.select_random_holiday, "04/05/#{next_year + 1}", "03:00", "pm", "07:44", "pm")
    page.add_partial_range_holiday(page.select_random_holiday, "05/11/#{next_year + 1}", "02:22", "am", "05/22/#{next_year + 1}", "04:44", "pm")
  end
end