class ManageProcess < BasePage

  frame_element
  wrapper_elements
  green_search_buttons

  expected_element :process_name

  element(:process_name) { |b| b.frm.text_field(name: "name") }
  element(:process_category) { |b| b.frm.select(name: "typeKey") }
  element(:hold_description) { |b| b.frm.text_area(name: "descr") }
  element(:owning_organization) { |b| b.frm.text_field(name: "ownerOrgId") }

  action(:lookup_organization) { |b| b.frm.button(title: "Search Field").click; b.loading.wait_while_present }

  element(:active) { |b| b.frm.radio(value: "active") }
  element(:disabled) { |b| b.frm.radio(value: "disabled") }
  element(:inactive) { |b| b.frm.radio(value: "inactive") }

end