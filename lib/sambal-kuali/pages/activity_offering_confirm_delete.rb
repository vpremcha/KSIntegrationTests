class ActivityOfferingConfirmDelete < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :delete_activity_offering_button

  element(:delete_activity_offering_button) { |b| b.frm.button(id: "u286") }
#  action(:delete_activity_offering) { |b| b.delete_activity_offering_button.click; b.loading.wait_while_present }
  action(:delete_activity_offering) { |b| b.frm.button(text: "Delete Activity Offering(s)").click; b.loading.wait_while_present }


end