class RolloverDetails < BasePage

  wrapper_elements
  frame_element

  expected_element :term

  element(:term) { |b| b.frm.text_field(name: "rolloverTargetTermCode") }
  action(:go) { |b| b.frm.button(text: "Go").click; b.loading.wait_while_present }

  value(:status) { |b| b.frm.div(data_label: "Status").span(index: 2).text } #status shows after rollover initiated

  value(:status_detail_msg) { |b| b.frm.div(id: "KS-RolloverResultsInfoSection").table.rows[1].text }
  element(:release_to_departments_button) { |b| b.frm.button(text: "Release to Departments") }
  action(:release_to_departments) { |b| b.release_to_departments_button.click; b.loading.wait_while_present }
  action(:re_do_rollover_link) { |b| b.frm.link(text: "Re-do Rollover").click; b.loading.wait_while_present }
  action(:re_do_rollover) { |b| b.re_do_rollover_link.click; b.loading.wait_while_present }

  value(:source_term) { |b| b.frm.div(data_label: "Source Term").span().text }
  value(:date_initiated) { |b| b.frm.div(data_label: "Date Initiated").span().text }
  value(:date_completed) { |b| b.frm.div(data_label: "Date Completed").span().text }
  value(:rollover_duration) { |b| b.frm.div(data_label: "Rollover Duration").span().text }
  value(:course_offerings_transitioned) { |b| b.frm.div(data_label: "Course Offerings").span().text[/^(\d+)/] }
  value(:course_offerings_exceptions) { |b| b.frm.div(data_label: "Course Offerings").span().text[/\d+(?=.exception)/] }
  value(:activity_offerings_transitioned) { |b| b.frm.div(data_label: "Activity Offerings").span().text[/^(\d+)/] }
  value(:activity_offerings_exceptions) { |b| b.frm.div(data_label: "Activity Offerings").span().text[/\d+(?=.exception)/] }

  element(:non_transitioned_courses_div) { |b| b.frm.div(class: "dataTables_wrapper")}  #TODO need persistent id
  element(:non_transitioned_courses_search) { |b| b.non_transitioned_courses_div.div(class: "dataTables_filter").text_field() }
  element(:non_transitioned_courses_table) { |b| b.non_transitioned_courses_div.table() }

  COURSE_COLUMN = 0
  REASON_COLUMN = 1

  value(:non_transitioned_courses_info) { |b| b.div(class: "dataTables_info") }
  action(:previous) { |b| b.frm.link(text: "Previous").click; b.loading.wait_while_present }
  action(:next) { |b| b.frm.link(text: "Next").click; b.loading.wait_while_present }


end