When /^I add requested delivery logistics to an activity offering$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create :seat_pool_list => {},
                            :personnel_list => []
end

And /^I save and process the requested delivery logistics$/ do
  #implemented with 'process' flag when delivery logistics created
end

And /^actual delivery logistics are created with the activity offering$/ do
  #actually checked in 'the activity offering is updated' step
end