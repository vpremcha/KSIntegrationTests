class DeleteTargetTerm < BasePage

  expected_element :term

  wrapper_elements
  frame_element

  element(:term) { |b| b.frm.text_field(name: "targetTermCode") }

  value(:term_id) { |b| b.frm.span(id: "u120").text } # Persistent ID needed!
  value(:term_start_date) { |b| b.frm.span(id: "u131").text } # Persistent ID needed!
  value(:term_end_date) { |b| b.frm.span(id: "u142").text } # Persistent ID needed!

  action(:go) { |b| b.frm.button(text: "Go").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:delete_target_term) { |b| b.frm.button(text: "Delete Target Term").click; b.loading.wait_while_present } # Persistent ID needed!

end