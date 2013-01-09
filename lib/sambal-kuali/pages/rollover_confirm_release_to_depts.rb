class RolloverConfirmReleaseToDepts < BasePage

  wrapper_elements
  frame_element

  expected_element :release_to_departments_button

  element(:release_to_departments_button) { |b| b.frm.button(text: "Release to Departments") }
  action(:confirm)  { |b| b.frm.checkbox(id: "approveCheckbox_control").set }
  action(:release_to_departments) { |b| b.release_to_departments_button.click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "Cancel").click; b.loading.wait_while_present }


end