class CreateProcess < BasePage
  
  frame_element
  wrapper_elements
  
  expected_element :process_name
  
  element(:process_name) { |b| b.frm.text_field(name: "name") }
  element(:process_category) { |b| b.frm.select(name: "typeKey") }
  element(:hold_description) { |b| b.frm.text_area(name: "descr") }
  element(:owning_organization) { |b| b.frm.text_field(name: "orgName") }
  
  action(:lookup_organization) { |b| b.frm.button(title: "Search Field").click; b.loading.wait_while_present }
  
  action(:create_process) { |b| b.frm.button(text: "Create process").click; b.loading.wait_while_present }
  
end