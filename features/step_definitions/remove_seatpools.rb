When /^I remove the seat pool with priority 1$/ do
  @activity_offering.edit_seatpool :seatpool_key => 1, :remove => true
  @activity_offering.edit_seatpool :seatpool_key => 2, :priority_after_reseq => 1
  @activity_offering.edit_seatpool :seatpool_key => 3, :priority_after_reseq => 2
end


When /^I remove all seat pools$/ do
  @activity_offering.edit_seatpool :seatpool_key => 1, :remove => true
  @activity_offering.edit_seatpool :seatpool_key => 2, :remove => true
  @activity_offering.edit_seatpool :seatpool_key => 3, :remove => true
end

When /^the seat pool priorities are re-sequenced$/ do
  #actually is implemented in the edit step and check in the 'the activity offering is updated when saved' step
end

And /^the seat pools? (?:are|is) removed$/ do
  #actually is implemented in the edit step and check in the 'the activity offering is updated when saved' step
end