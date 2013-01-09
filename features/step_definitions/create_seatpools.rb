When /^I create a seat pool for an activity offering by completing all fields$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create :requested_delivery_logistics_list => {},
                            :personnel_list => []
  end

Then /^the percent allocated for each row is updated$/ do
  on ActivityOfferingMaintenance do |page|
         @activity_offering.seat_pool_list.each do |key, seat_pool|
           page.pool_percentage(seat_pool.population_name).should == seat_pool.percent_of_total(@activity_offering.max_enrollment)
         end
    end
end

When /^seats is set higher than max enrollment$/ do
  @activity_offering.edit_seatpool :seats => (@activity_offering.max_enrollment.to_i + 1).to_s
end

Then /^a warning message is displayed about seats exceeding max enrollment$/ do
  on ActivityOfferingMaintenance do |page|
    page.seat_count_remaining.should == "0"
    page.percent_seats_remaining.should == "0"
    page.seats_remaining.should =~ /WARNING: Total seats exceeding the total max enrollment quantity by \d+ seats!/
  end
end

When /^I create seat pools for an activity offering and priorities are duplicated and not sequential$/ do
  @activity_offering = make ActivityOffering

  seatpool_hash = {}
  seatpool_hash[1] = make SeatPool, :population_name => "Core", :seats => 10, :priority => 2, :priority_after_reseq => 2
  seatpool_hash[2] = make SeatPool, :population_name => "DSS", :seats => 11, :priority => 2, :priority_after_reseq => 1
  seatpool_hash[3] = make SeatPool, :population_name => "Fraternity/Sorority", :seats => 12, :priority => 4, :priority_after_reseq => 3

  @activity_offering.create   :seat_pool_list => seatpool_hash,
                              :requested_delivery_logistics_list => {},
                              :personnel_list => []

end

Then /^the seat pool priorities are correctly sequenced$/ do
  #checked in the 'the activity offering is updated when saved' step
  #@activity_offering.seat_pool_list[1].priority = 2
  #@activity_offering.seat_pool_list[2].priority = 1
  #@activity_offering.seat_pool_list[3].priority = 3
end

When /^I add a seat pool using a population that is already used for that activity offering$/ do
  @activity_offering = make ActivityOffering

  seatpool_hash = {}
  seatpool_hash["Core"] = make SeatPool, :population_name => "Core", :seats => 10, :priority => 1
  seatpool_hash["dup"] = make SeatPool, :population_name => "Core", :seats => 11, :priority => 2, :exp_add_succeed => false

  @activity_offering.create  :seat_pool_list => seatpool_hash,
                             :requested_delivery_logistics_list => {},
                              :personnel_list => []
end

Then /^an error message is displayed about the duplicate population$/ do
  on ActivityOfferingMaintenance do |page|
    page.seatpool_first_msg.should match /.*'#{@activity_offering.seat_pool_list.values[0].population_name}' is already added.*/
  end
end

When /^I add a seat pool without specifying a population$/ do
  @activity_offering = make ActivityOffering

  seatpool1 = make SeatPool, :population_name => "", :seats => 10, :priority => 2, :exp_add_succeed => false

  @activity_offering.create :seat_pool_list => {"blank" => seatpool1},
                            :requested_delivery_logistics_list => {},
                            :personnel_list => []

end

Then /^an error message is displayed about the required seat pool fields$/ do
  on ActivityOfferingMaintenance do |page|
    sleep 2 #TODO: required by headless
    page.validation_error_dialog_text.should == "The form contains errors. Please correct these errors and try again."
    page.close_validation_error_dialog
    #page.seatpool_first_msg.should match /.*Required*/
  end
  #remove blank to update expected
  @activity_offering.seat_pool_list.delete("blank")
end
