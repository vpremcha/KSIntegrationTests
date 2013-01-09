class EditAcademicCalendar < BasePage

  expected_element :academic_calendar_name

  wrapper_elements
  frame_element

  action(:information_tab) { |b| b.frm.link(text: "Information").click }
  action(:terms_tab) { |b| b.frm.link(text: "Terms").click }
  
  element(:academic_calendar_name) { |b| b.frm.text_field(name: "academicCalendarInfo.name") }
  element(:organization) { |b| b.frm.select(name: "academicCalendarInfo.adminOrgId") }
  element(:calendar_start_date) { |b| b.frm.text_field(name: "academicCalendarInfo.startDate") }
  element(:calendar_end_date) { |b| b.frm.text_field(name: "academicCalendarInfo.endDate") }

  action(:event_toggle) { |b| b.frm.link(id: "acal-info-event_toggle").click; sleep 1 }

  element(:event_type) { |b| b.frm.select(name: "newCollectionLines['events'].eventTypeKey") }
  element(:event_start_date) { |b| b.frm.text_field(name: "newCollectionLines['events'].startDate") }
  element(:event_end_date) { |b| b.frm.text_field(name: "newCollectionLines['events'].endDate") }
  element(:event_start_time) { |b| b.frm.text_field(name: "newCollectionLines['events'].startTime") }
  element(:event_end_time) { |b| b.frm.text_field(name: "newCollectionLines['events'].endTime") }
  element(:event_start_ampm) { |b| b.frm.select(name: "newCollectionLines['events'].startTimeAmPm") }
  element(:event_end_ampm) { |b| b.frm.select(name: "newCollectionLines['events'].endTimeAmPm") }
  element(:all_day) { |b| b.frm.checkbox(name: "newCollectionLines['events'].allDay") }
  element(:date_range) { |b| b.frm.checkbox(name: "newCollectionLines['events'].dateRange") }
  element(:add_event) { |b| b.frm.button(id: "u177_add") } # Persistent ID needed! Note that there can be multiple Adds on the page. Element identifiers for all need to be helpful
  element(:make_official_button) { |b| b.frm.button(text: "Make Official") } # Persistent ID needed!

  action(:make_official) { |p| p.make_official_button.click; p.loading.wait_while_present }
  action(:save) { |b| b.frm.button(text: "Save").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:delete_draft) { |b| b.frm.link(text: "Delete Draft").click } # Persistent ID needed!

  element(:term_type) { |b| b.frm.select(name: "newCollectionLines['termWrapperList'].termType") }
  element(:term_start_date) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList'].startDate") }
  element(:term_end_date) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList'].endDate") }
  
  action(:add_term) { |b| b.frm.button(id: "u666_add").click; loading.wait_while_present } # Persistent ID needed!

  element(:term_info_name) { |b| b.frm.text_field(name: "termWrapperList[0].name") }
  element(:term_info_start_date) { |b| b.frm.text_field(name: "termWrapperList[0].startDate") }
  element(:term_info_end_date) { |b| b.frm.text_field(name: "termWrapperList[0].instructionalDays") }
  
  element(:key_date_type) { |b| b.frm.select(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].keyDateType") }
  element(:key_date_start_date) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].startDate") }
  element(:key_date_start_time) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].startTime") }
  element(:key_date_start_ampm) { |b| b.frm.select(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].startTimeAmPm") }
  element(:key_date_end_date) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].endDate") }
  element(:key_date_end_time) { |b| b.frm.text_field(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].endTime") }
  element(:key_date_end_ampm) { |b| b.frm.select(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].endTimeAmPm") }
  element(:key_date_all_day) { |b| b.frm.checkbox(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].allDay") }
  element(:key_date_date_range) { |b| b.frm.checkbox(name: "newCollectionLines['termWrapperList_0_.keyDatesGroupWrappers_0_.keydates'].dateRange") }

  action(:key_date_add) { |b| b.frm.button(id: "u1326_line0_line0_add").click } # Persistent ID needed!
  action(:delete_keydate_group) { |b| b.frm.button(text: "delete keydate group").click } # Persistent ID needed!

end