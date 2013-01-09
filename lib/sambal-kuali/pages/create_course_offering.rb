class CreateCourseOffering < BasePage

  wrapper_elements
  frame_element

  expected_element :target_term

  element(:target_term) { |b| b.frm.div(data_label: "Target Term").text_field() }
  element(:catalogue_course_code) { |b| b.frm.div(data_label: "Catalog Course Code").text_field() }

  action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:create_offering) { |b| b.frm.button(id: "createOfferingButton").click; b.loading.wait_while_present }
  action(:search) { |b| b.frm.link(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!

  element(:create_offering_from_div)  { |b| b.frm.div(id: "KS-CourseOffering-LinkSection").text_field() }
  action(:create_from_existing_offering)  { |b| b.create_offering_from_div.link(text: /Existing Offering/).click }
  element(:suffix) { |b| b.frm.div(data_label: "Add Suffix").text_field() }


end