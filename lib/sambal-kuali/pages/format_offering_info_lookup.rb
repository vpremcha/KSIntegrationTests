class FormatOfferingInfoLookup < BasePage
  
  wrapper_elements
  frame_element
  green_search_buttons
  
  element(:course_offering_id) { |b| b.frm.text_field(name: "criteriaFields[courseOfferingId]") }

end