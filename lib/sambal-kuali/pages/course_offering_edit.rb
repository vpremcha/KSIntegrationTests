class CourseOfferingEdit < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :course_code_element

  action(:submit) { |b| b.frm.button(text: "submit").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "cancel").click; b.loading.wait_while_present }

  element(:course_code_element) { |b| b.frm.div(data_label: "Course Offering Code").span(index: 2) }
  value(:course_code) { |b| b.frm.course_code_element.text() }
  element(:change_suffix) { |b| b.frm.div(data_label: "Change Suffix").text_field() }

  element(:grading_option_letter) { |b| b.frm.radio(value: "kuali.resultComponent.grade.letter") }
  element(:credit_type_option_fixed) { |b| b.frm.radio(value: "kuali.result.values.group.type.fixed") }
  element(:credits) { |b| b.frm.div(data_label: "Credits").text_field() }

  action(:final_exam_option_standard) { |b| b.frm.radio(value: "STANDARD").set; b.loading.wait_while_present}
  action(:final_exam_option_alternate) { |b| b.frm.radio(value: "ALTERNATE").set; b.loading.wait_while_present }
  action(:final_exam_option_none) { |b| b.frm.radio(value: "NONE").set; b.loading.wait_while_present }

  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-CourseOfferingEdit-FormatOfferingSubSection").table() }
  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  ACTIONS_COLUMN = 3

  element(:select_format_type_add) {|b| b.frm.delivery_formats_table.rows[1].cells[FORMAT_COLUMN].select() }
  element(:select_grade_roster_level_add) {|b| b.frm.delivery_formats_table.rows[1].cells[GRADE_ROSTER_LEVEL_COLUMN].select() }
  element(:delivery_format_add_element) {|b| b.frm.delivery_formats_table.rows[1].cells[ACTIONS_COLUMN].button(text: "add")  }
  action(:delivery_format_add) {|b| b.delivery_format_add_element.click; b.loading.wait_while_present   }

  def grade_roster_level(format)
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().selected_options[0].text
  end

  def final_exam_driver(format)
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].text
  end


  element(:waitlist_checkbox) { |b| b.frm.div(data_label: "Waitlists").checkbox() }
  value(:has_waitlist?) { |b| b.frm.waitlist_checkbox.value }
  action(:waitlist_on )  { |b| b.frm.waitlist_checkbox.set; b.loading.wait_while_present }
  action(:waitlist_off )  { |b| b.frm.waitlist_checkbox.clear; b.loading.wait_while_present }
  action(:waitlist_option_course_offering) { |b| b.frm.div(data_label: "Waitlist Level").radio(index: 0).set }
  action(:waitlist_option_activity_offering) { |b| b.frm.div(data_label: "Waitlist Level").radio(index: 1).set }
  element(:waitlist_select) { |b| b.frm.div(data_label: "Waitlist Type").select() }

  ID_COLUMN = 0
  NAME_COLUMN = 1
  AFFILIATION_COLUMN = 2
  #ACTIONS_COLUMN -- defined above

  element(:personnel_table) { |b| b.frm.div(id: "KS-ActivityOffering-PersonnelSection").table() }

  element(:add_person_id) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].text_field() }
  action(:lookup_person) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].image().click; b.loading.wait_while_present } # Need persistent ID!
  element(:add_affiliation) { |b| b.personnel_table.rows[1].cells[AFFILIATION_COLUMN].select() }
  element(:add_personnel_button_element) { |b| b.personnel_table.rows[1].button(text: "add") }
  action(:add_personnel) { |b| b.add_personnel_button_element.click; b.loading.wait_while_present } # Needs persistent ID value

  def update_affiliation(id, affiliation)
    target_person_row(id).select(index: 0).select affiliation
  end

  def get_affiliation(id)
    target_person_row(id).cells[AFFILIATION_COLUMN].select.selected_options[0].text  #cell is hard-coded, getting this value was very problematic
  end

  def get_person_name(id)
    target_person_row(id).cells[NAME_COLUMN].text  #cell is hard-coded, getting this value was very problematic
  end

  def delete_person(id)
    target_person_row(id).button.click
    loading.wait_while_present
  end

  ORG_ID_COLUMN = 0
  ORG_NAME_COLUMN = 1
  ORG_ACTIONS_COLUMN = 2

  element(:admin_orgs_table)  { |b| b.frm.div(id: "KS-CourseOfferingEdit-OrganizationSection").table() }

  element(:add_org_id) { |b| b.admin_orgs_table.rows[1].cells[ORG_ID_COLUMN].text_field() }
  action(:lookup_org) { |b| b.admin_orgs_table.rows[1].cells[ORG_ID_COLUMN].button().click; b.loading.wait_while_present } # Need persistent ID!
  action(:add_org) { |b| b.admin_orgs_table.rows[1].button(text: "add").click; b.loading.wait_while_present } # Needs persistent ID value

  def get_org_name(id)
    target_orgs_row(id).cells[NAME_COLUMN].text  #cell is hard-coded, getting this value was very problematic
  end

  def delete_org(id)
    target_orgs_row(id).button(text: "delete").click
    loading.wait_while_present
  end

  element(:honors_flag) { |b| b.div(data_label: "Honors Flag").checkbox() }

  private

  def target_orgs_row(org_id)
    #workaround here as id field value is not returned in rows[1].text
    #admin_orgs_table.row(text: /#{Regexp.escape(org_id)}/)
    admin_orgs_table.rows[1..-1].each do |row|
       if row.cells[ORG_ID_COLUMN].text_field().value == org_id
         return row
       end
    end
  end

  def target_person_row(id)
    personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end
end