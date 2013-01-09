When /^I delete the selected three AOs$/ do
  $total_number = @course_offering.ao_list.count
  @ao_code_list = [@course_offering.ao_list[0],@course_offering.ao_list[1],@course_offering.ao_list[2]]
  @course_offering.delete_ao_list :code_list =>  @ao_code_list
end

Then /^The AOs are Successfully deleted$/ do
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number - 3
end


When /^I delete an AO with Draft state$/ do
  $total_number = @course_offering.ao_list.count
  ao_code = @course_offering.ao_list[0]
  @course_offering.delete_ao :ao_code =>  @course_offering.ao_list[0]
end

Then /^The AO is Successfully deleted$/ do
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number - 1
end


