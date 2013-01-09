When /^I create an Academic Calendar$/ do
  @calendar = make AcademicCalendar
  @calendar.create
end

Then /^the Make Official button should become active$/ do
  on EditAcademicCalendar do |page|
    page.make_official_button.enabled?.should == true # TODO: Figure out why ".should_be enabled" does not work.
  end
end

When /^I search for the calendar$/ do
  @calendar.search
end

When /^I search for the Academic Calendar using (.*)$/ do |arg|
  search_terms = { :wildcards=>"*", :"partial name"=>@calendar.name[0..2] }
  visit MainMenu do |page|
    page.enrollment_home
  end
  on Enrollment do |page|
    page.search_for_calendar_or_term
  end
  on CalendarSearch do |page|
    page.search_for "Academic Calendar", search_terms[arg.to_sym]

    while page.showing_up_to.to_i < page.total_results.to_i
      if page.results_list.include? @calendar.name
        break
      else
        page.next
      end
    end
  end
end

Then /^the calendar (.*) appear in search results$/ do |arg|
  on CalendarSearch do |page|
    if arg == "should"
      page.results_list.should include @calendar.name
    else
      begin
        page.results_list.should_not include @calendar.name
      rescue Watir::Exception::UnknownObjectException
        # Implication here is that there were no search results at all.
      end
    end
  end
end

When /^I make the calendar official$/ do
  @calendar.make_official
end

Then /^the calendar (.*) be set to Official$/ do |arg|
  on CalendarSearch do |page|
    if arg == "should"
      page.calendar_status(@calendar.name).should == "Official"
    else
      page.calendar_status(@calendar.name).should_not == "Official"
    end
  end
end

When /^I copy the Academic Calendar$/ do
  @calendar_copy = make AcademicCalendar
  @calendar_copy.copy_from @calendar.name
end

When /^I update the Academic Calendar$/ do
  @calendar.search
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  @calendar.name = random_alphanums.strip
  @calendar.start_date = "02/15/#{next_year[:year]}"
  @calendar.end_date = "07/06/#{next_year[:year] + 1}"
  on EditAcademicCalendar do |page|
    page.academic_calendar_name.set @calendar.name
    page.calendar_start_date.set @calendar.start_date
    page.calendar_end_date.set @calendar.end_date
    page.save
  end
end

When /^I delete the Academic Calendar draft$/ do
  on EditAcademicCalendar do |page|
    page.delete_draft
    page.alert.ok
  end
end

Then /^the calendar should reflect the updates$/ do
  on CalendarSearch do |page|
    page.edit @calendar.name
  end
  on EditAcademicCalendar do |page|
    page.academic_calendar_name.value.should == @calendar.name
    page.calendar_start_date.value.should == @calendar.start_date
    page.calendar_end_date.value.should == @calendar.end_date
  end
end