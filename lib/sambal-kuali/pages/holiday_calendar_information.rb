class HolidayCalendarInfo < HolidayBase

  include Holidays

  expected_element :last_saved_element

  frame_element
  wrapper_elements

  element(:last_saved_element) { |b| b.frm.span(id: "u35_span") } # Persistent ID needed!

  value(:last_saved) { |b| b.last_saved_element.text } # Persistent ID needed!
  value(:calendar_name) { |b| b.frm.span(id: "u40").text } # Persistent ID needed!
  value(:organization) { |b| b.frm.span(id: "u57").text } # Persistent ID needed!

  element(:holiday_table) { |b| b.frm.table(id: "u104") } # Persistent ID needed!

  value(:holiday_calendar_name) { |b| b.frm.span(id: "u404_line0").text } # Persistent ID needed!
  value(:holiday_calendar_org) { |b| b.frm.span(id: "u419_line0").text } # Persistent ID needed!
  value(:holiday_calendar_start_date) { |b| b.frm.span(id: "u434_line0").text } # Persistent ID needed!
  value(:holiday_calendar_end_date) { |b| b.frm.span(id: "u449_line0").text } # Persistent ID needed!
  
  element(:holidays_table) { |b| b.frm.table(id: "u464_line0") } # Persistent ID needed!

end