class CopyHolidayCalendar < BasePage

  expected_element :name

  wrapper_elements
  frame_element

  value(:source_name) { |b| b.frm.div(id: "u38").text } # Persistent ID needed!
  value(:source_start_date) { |b| b.frm.span(id: "u47").text } # Persistent ID needed!
  value(:source_end_date) { |b| b.frm.span(id: "u56").text } # Persistent ID needed!

  element(:start_blank_calendar) { |b| b.frm.link(text: "Start a blank calendar instead?").click }
  element(:choose_different_calendar) { |b| b.frm.link(text: "Choose a Different Calendar") }
  element(:name) { |b| b.frm.text_field(name: "newCalendarName") }
  element(:start_date) { |b| b.frm.text_field(name: "newCalendarStartDate") }
  element(:end_date) { |b| b.frm.text_field(name: "newCalendarEndDate") }

  action(:copy_academic_calendar) { |b| b.frm.button(text: /Copy Holiday Calendar/).click; b.loading.wait_while_present }
  
end