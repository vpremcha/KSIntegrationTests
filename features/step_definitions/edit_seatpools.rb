When /^I change the seat pool count and expiration milestone$/ do
  @activity_offering.edit_seatpool :seats => 20,:expiration_milestone => "Last Day of Registration"
end

Then /^the seats remaining is updated$/ do
  on ActivityOfferingMaintenance do |page|
    sleep 1 #TODO required for headless
    page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
  end
end

When /^I edit an existing activity offering with (\d+) seat pools?$/ do |number|
  @activity_offering = make ActivityOffering

  temp_list = {}
  ctr = 0
  #create required number of seatpools
  while ctr < number.to_i do
    ctr = ctr + 1
    seatpool = make SeatPool, :priority => (ctr)
    temp_list[ctr] = seatpool
  end

  @activity_offering.create :seat_pool_list => temp_list,
                            :requested_delivery_logistics_list => {},
                            :personnel_list => []

  @activity_offering.save
  on ActivityOfferingMaintenanceView do |page|
    page.home
  end
  #now reopen course offering for ao edit
  @course_offering.manage

  on ManageCourseOfferings do |page|
    page.edit @activity_offering.code
  end
end

When /^I switch the priorities for 2 seat pools$/ do
  @activity_offering.edit_seatpool :seatpool_key => 1,:priority => 2, :priority_after_reseq => 2
  @activity_offering.edit_seatpool :seatpool_key => 2,:priority => 1, :priority_after_reseq => 1
end


And /^I increase the overall max enrollment$/ do
  @activity_offering.edit :max_enrollment => @activity_offering.max_enrollment.to_i + 20
end


#should match "seat pool is saved","updated seat pool is saved","seat pool is not saved", etc
#in all cases activity offering (expected) must be updated to match actual page
#Then /^the.*seat pool.*(?:saved|saving).*$/ do

#end

And /^the updated seat pool priorities are saved$/ do
  #checked in the 'the activity offering is updated when saved' step
end


And /^the seat pool is not saved with the activity offering$/ do
  #checked in the 'the activity offering is updated when saved' step
end


#checks the read only page after submit, and then reopens in edit mode to check persistence
Then /^the activity offering is updated when saved$/ do

  @activity_offering.save
  on ActivityOfferingMaintenanceView do |page|

    page.first_msg.should match /.*successfully submitted.*/

    @activity_offering.personnel_list.each do |p|
      page.get_affiliation(p.id).should == p.affiliation.to_s
      page.get_inst_effort(p.id).should == p.inst_effort.to_s
    end

    @activity_offering.seat_pool_list.values.each do |sp|
      page.get_seats(sp.population_name).should == sp.seats.to_s
      page.get_expiration_milestone(sp.population_name).should == sp.expiration_milestone
      #  page.get_pool_percentage(sp.population_name).should == sp.percent_of_total
      page.get_priority(sp.population_name).should == sp.priority.to_s
    end

    page.activity_code.should == @activity_offering.code
    page.max_enrollment.should == @activity_offering.max_enrollment.to_s

    if  @activity_offering.actual_delivery_logistics_list.length != 0
      page.actual_logistics_table.rows[1..-1].each do |row|
        row_key = "#{page.get_actual_logistics_days(row)}#{page.get_actual_logistics_start_time(row)}".delete(' ')
        adl = @activity_offering.actual_delivery_logistics_list[row_key]
        if row_key != ''
          if adl.tba?
            page.get_actual_logistics_tba(row).should == "TBA"
          else
            page.get_actual_logistics_tba(row).should == ""
          end
          page.get_actual_logistics_days(row).delete(' ').should == adl.days
          page.get_actual_logistics_start_time(row).should == "#{adl.start_time} #{adl.start_time_ampm.upcase}"
          page.get_actual_logistics_end_time(row).should == "#{adl.end_time} #{adl.end_time_ampm.upcase}"
          page.get_actual_logistics_facility(row).should == adl.facility_long_name
          page.get_actual_logistics_room(row).should == adl.room
          #TODO - validate (facility) features when implemented
        end
      end
    end

    page.seat_pool_count.should == @activity_offering.seat_pool_list.count.to_s
    page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
    page.course_url.should == @activity_offering.course_url
    page.evaluation.should == @activity_offering.evaluation.to_s
    page.honors.should == @activity_offering.honors_course.to_s

    page.home
  end


  #seat_pool priorities are resequenced when you go back into to edit AO
  @activity_offering.resequence_seatpools()

  #reopens activity offering in edit mode to recheck everything persisted
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit @activity_offering.code
  end

  on ActivityOfferingMaintenance do |page|
    page.total_maximum_enrollment.value.should == @activity_offering.max_enrollment.to_s

    if  @activity_offering.actual_delivery_logistics_list.length != 0
      page.actual_logistics_table.rows[1..-1].each do |row|
        row_key = "#{page.get_actual_logistics_days(row)}#{page.get_actual_logistics_start_time(row)}".delete(' ')
        adl = @activity_offering.actual_delivery_logistics_list[row_key]
        if row_key != ''
          if adl.tba?
            page.get_actual_logistics_tba(row).should == "TBA"
          else
            page.get_actual_logistics_tba(row).should == ""
          end
          page.get_actual_logistics_days(row).delete(' ').should == adl.days
          page.get_actual_logistics_start_time(row).should == "#{adl.start_time} #{adl.start_time_ampm.upcase}"
          page.get_actual_logistics_end_time(row).should == "#{adl.end_time} #{adl.end_time_ampm.upcase}"
          page.get_actual_logistics_facility(row).should == adl.facility_long_name
          page.get_actual_logistics_room(row).should == adl.room
          #TODO - validate (facility) features when implemented
        end
      end
    end

    page.seat_pool_count.should == @activity_offering.seat_pool_list.count.to_s
    page.course_url.value.should == @activity_offering.course_url

    @activity_offering.personnel_list.each do |p|
      page.get_affiliation(p.id).should == p.affiliation.to_s
      page.get_inst_effort(p.id).should == p.inst_effort.to_s
    end

    @activity_offering.seat_pool_list.values.each do |seatpool|
      page.get_seats(seatpool.population_name).should == seatpool.seats.to_s
      page.get_expiration_milestone(seatpool.population_name).should == seatpool.expiration_milestone
      page.pool_percentage(seatpool.population_name).should == seatpool.percent_of_total(@activity_offering.max_enrollment)
      page.get_priority(seatpool.population_name).should == seatpool.priority.to_s
    end

    page.requires_evaluation.set?.should == @activity_offering.evaluation
  end
end

Given /^I am managing a course offering$/ do
  @course_offering = make CourseOffering
  @course_offering.manage
end
