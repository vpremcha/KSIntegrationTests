class AddHold < HoldBase

  expected_element :hold_name

  frame_element
  wrapper_elements
  hold_elements
  
  action(:save) { |b| b.frm.button(text: "Save").click; b.loading.wait_while_present } # Needs persistent ID

end