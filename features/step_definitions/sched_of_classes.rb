Then /^I am using the schedule of classes page$/ do
  go_to_display_schedule_of_classes
end

When /^I search for course offerings by course by entering a subject code$/ do
  @schedule_of_classes = make ScheduleOfClasses, :course_search_parm => "CHEM", :exp_course_list => ["CHEM221","CHEM455"]
  @schedule_of_classes.display
end

When /^I search for course offerings by course by entering a subject code: (.*)$/ do |subject_code|
  @schedule_of_classes = make ScheduleOfClasses, :course_search_parm => subject_code
  @schedule_of_classes.display
end



Then /^a list of course offerings with that subject code is displayed$/ do
  @schedule_of_classes.check_results_for_subject_code_match(@schedule_of_classes.course_search_parm)
end

Then /^the course offering details for a particular offering can be shown$/ do
  @schedule_of_classes.expand_course_details
end

Then /^the course offering details for all offerings can be shown$/ do
  @schedule_of_classes.expand_all_course_details
end

When /^I search for course offerings by course by entering a course offering code$/ do
  @schedule_of_classes = make ScheduleOfClasses, :course_search_parm => "ENGL103", :exp_course_list => ["ENGL103"]
  @schedule_of_classes.display
end

Then /^a list of course offerings with that course offering code is displayed$/ do
  @schedule_of_classes.check_expected_results
end

When /^I search for course offerings by instructor$/ do
  @schedule_of_classes = make ScheduleOfClasses, :type_of_search => "Instructor", :instructor_principal_name => "B.JOHND", :exp_course_list => ["BIOL200","BIOL315","CHEM142","CHEM238","ENGL105"]
  @schedule_of_classes.display
end

Then /^a list of course offerings with activity offerings with that instructor is displayed$/ do
  @schedule_of_classes.check_results_for_instructor
end

When /^I search for course offerings by department$/ do
  @schedule_of_classes = make ScheduleOfClasses, :type_of_search => "Department", :department_short_name => "ENGL", :exp_course_list => ["ENGL103","ENGL225","ENGL281"]
  @schedule_of_classes.display
end

Then /^a list of course offerings for that department is displayed$/ do
   @schedule_of_classes.check_expected_results
end

When /^I search for course offerings by title and department by entering a keyword$/ do
  @schedule_of_classes = make ScheduleOfClasses, :type_of_search => "Title & Description", :keyword => "computer", :exp_course_list => ["CHEM426"]
  @schedule_of_classes.display
end

Then /^a list of course offerings with that keyword is displayed$/ do
  @schedule_of_classes.check_expected_results
end

When /^I search for course offerings that are in draft status$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the course is not displayed in the list of course offerings$/ do
  pending # express the regexp above with the code you wish you had
end