class AcademicTermLookup < BasePage
  
  wrapper_elements
  frame_element
  green_search_buttons
  
  element(:code) { |b| b.frm.text_field(name: "criteriaFields[code]") }
  element(:year) { |b| b.frm.text_field(name: "criteriaFields[startDate]") }
  
end