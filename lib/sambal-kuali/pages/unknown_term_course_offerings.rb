class UnknownTermCourseOfferings < BasePage

  wrapper_elements
  frame_element

  element(:i_understand) { |b| b.frm.checkbox(name: "acceptIndicator") }

  action(:release_to_departments) { |b| b.frm.button(id: "u109").click; b.loading.wait_while_present } # Persistent ID needed!

end