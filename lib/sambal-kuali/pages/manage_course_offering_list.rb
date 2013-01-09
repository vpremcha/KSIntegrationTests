class ManageCourseOfferingList < BasePage

  wrapper_elements
  frame_element

  expected_element :subject_code

  element(:co_results_div) { |b| b.frm.div(id: "KS-CourseOfferingManagement-CourseOfferingResultSection") }
  element(:subject_code) { |b| b.frm.co_results_div.h3.span() }

  action(:approve_subject_code_for_scheduling) { |b| b.frm.co_results_div.link(text: "Approve Subject Code for Scheduling").click; b.loading.wait_while_present }
  action(:create_course_offering) { |b| b.frm.co_results_div.button(text: "Create Course Offering").click; b.loading.wait_while_present } #TODO persistent id

  SELECT_COLUMN = 0
  CO_CODE_COLUMN = 1
  CO_STATUS_COLUMN = 2
  CO_TITLE_COLUMN = 3
  CO_CREDITS_COLUMN = 4
  CO_GRADING_COLUMN = 5
  ACTIONS_COLUMN = 6

  element(:course_offering_results_table) { |b| b.frm.div(id: "KS-CourseOfferingManagement-CourseOfferingListSection").table() }


  def view_course_offering(co_code)
    course_offering_results_table.link(text: co_code).click
    loading.wait_while_present
  end

  def target_row(co_code)
    course_offering_results_table.row(text: /\b#{Regexp.escape(co_code)}\b/)
  end

  def copy(co_code)
    target_row(co_code).link(text: "Copy").click
    loading.wait_while_present
  end

  def edit(co_code)
    target_row(co_code).link(text: "Edit").click
    loading.wait_while_present(120)
  end

  def manage(co_code)
    target_row(co_code).link(text: "Manage").click
    loading.wait_while_present(120)
  end

  def delete(co_code)
    if target_row(co_code).link(text: "Delete").exists?
      target_row(co_code).link(text: "Delete").click
      loading.wait_while_present
    else
      raise "delete not enabled for course offering code: #{co_code}"
    end
  end

  def co_list
    co_codes = []
    course_offering_results_table.rows.each { |row| co_codes << row[CO_CODE_COLUMN].text }
    co_codes.delete_if { |co_code| co_code.strip == "" }
    co_codes
  end

end