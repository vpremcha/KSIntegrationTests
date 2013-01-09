class EnrollmentFeeLookup < BasePage
  
  wrapper_elements
  frame_element
  green_search_buttons
  
  element(:identifier) { |b| b.frm.text_field(name: "criteriaFields[id]") }
  element(:reference_object_uri) { |b| b.frm.text_field(name: "criteriaFields[refObjectURI]") }
  element(:reference_object) { |b| b.frm.text_field(name: "criteriaFields[refObjectId]") }
  
end