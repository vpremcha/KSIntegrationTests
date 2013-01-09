class TermLookup < BasePage

  wrapper_elements
  frame_element
  
  element(:id) { |b| b.frm.text_field(name: "criteriaFields[id]") }
  element(:namespace) { |b| b.frm.select(name: "criteriaFields[specification.namespace]") }
  element(:name) { |b| b.frm.text_field(name: "criteriaFields[specification.name]") }
  element(:data_type) { |b| b.frm.text_field(name: "criteriaFields[specification.type]") }

  action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:clear_values) { |b| b.frm.button(text: "clear values").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:create_new) { |b| b.frm.link(title: "Create New Term with").click }
  
end