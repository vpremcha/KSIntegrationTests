class CourseOfferingInfoLookup < BasePage

  expected_element :term_id

  wrapper_elements
  frame_element
  green_search_buttons

  element(:term_id) { |b| b.frm.text_field(name: "criteriaFields[termId]") }
  element(:subject_area) { |b| b.frm.text_field(name: "criteriaFields[subjectArea]") }

end