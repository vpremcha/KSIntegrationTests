class CopyCourseOffering < BasePage

  wrapper_elements
  frame_element

  expected_element :create_copy_element

  element(:co_copy_div) { |b| b.frm.div(id: "copyCourseOfferingPage") }
  value(:subject_code) { |b| b.frm.co_copy_div.div(data_label: "Course Offering Code").span.text() }

  element(:create_copy_element) { |b| b.frm.co_copy_div.button(text: "Create Copy") }
  action(:create_copy) { |b| b.create_copy_element.click; b.loading.wait_while_present(120) }

end