When /^I initiate a rollover by specifying source and target terms$/ do
  @rollover = make Rollover
  @rollover.perform_rollover
end

Then /^the results of the rollover are available$/ do
  @rollover.wait_for_rollover_to_complete
  #TODO validation
  #page.source_term.should ==
  #page.date_initiated.should ==
  #page.date_completed.should ==
  #page.rollover_duration.should ==
  #page.course_offerings_transitioned.should ==
  #page.course_offerings_exceptions.should ==
  #page.activity_offerings_transitioned.should ==
  #page.activity_offerings_exceptions.should ==
  #page.non_transitioned_courses_table.rows[1].cells[0].text #first exception
end

Then /^course offerings are copied to the target term$/ do
  #TODO validation
end

Then /^the rollover can be released to departments$/ do
  @rollover.release_to_depts
  #TODO validation
end