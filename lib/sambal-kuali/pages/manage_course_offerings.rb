class ManageCourseOfferings < BasePage

  wrapper_elements
  frame_element

  expected_element :term

  element(:term) { |b| b.frm.text_field(name: "termCode") }
  element(:course_offering_code) { |b| b.frm.radio(value: "courseOfferingCode") }
  element(:subject_code) { |b| b.frm.radio(value: "subjectCode") }
  element(:input_code) { |b| b.frm.text_field(name: "inputCode") }

  element(:manage_offering_links_div) { |b| b.frm.div(id: "KS-CourseOfferingManagement-CourseOfferingLinks")}
  action(:manage_registration_groups) { |b| b.manage_offering_links_div.link(text: "Manage Registration Groups").click; b.loading.wait_while_present }

  action(:show) { |b| b.frm.button(text: "Show").click; sleep 2; b.loading.wait_while_present } # Persistent ID needed!

  value(:course_title) { |b| b.frm.div(id: "KS-CourseOfferingManagement-ActivityOfferingResultSection").h3(index: 0).text }
  action(:edit_offering) { |b| b.frm.link(id: "u327").click; b.loading.wait_while_present } # Persistent ID needed!

  element(:format) { |b| b.frm.select(name: "formatIdForNewAO") }
  element(:activity_type) { |b| b.frm.select(name: "activityIdForNewAO") }
  element(:quantity) { |b| b.frm.text_field(name: "noOfActivityOfferings") }

  
  action(:add) { |b| b.frm.button(text: "Add").click; b.loading.wait_while_present } # Persistent ID needed!
  
  action(:select_all) { |b| b.frm.link(id: "KS-CourseOfferingManagement-SelectAll").click; b.loading.wait_while_present }

  AO_CODE = 1
  AO_STATUS = 2
  AO_TYPE = 3
  AO_FORMAT = 4
  AO_INSTRUCTOR = 5
  AO_MAX_ENR = 6

  element(:activity_offering_results_table) { |b| b.frm.table(class: "uif-tableCollectionLayout dataTable") } # Persistent ID needed!
  element(:selected_offering_actions) { |b| b.frm.select(name: "selectedOfferingAction") }

  action(:go) { |b| b.frm.button(text: "Go").click; b.loading.wait_while_present }

  def view_activity_offering(code)
    activity_offering_results_table.link(text: code).click
    loading.wait_while_present
  end

  def target_row(code)
    activity_offering_results_table.row(text: /\b#{Regexp.escape(code)}\b/)
  end

  def ao_db_id(code)
    target_row(code).cells[AO_CODE].link.attribute_value("href").scan(/aoInfo.id=(.*)&dataObjectClassName/)[0][0]
  end

  def copy(code)
    target_row(code).link(text: "Copy").click
    loading.wait_while_present
  end

  def edit(code)
    target_row(code).link(text: "Edit").click
    loading.wait_while_present(120)
  end

  def delete(code)
    retVal = false
    if target_row(code).link(text: "Delete").exists?
      target_row(code).link(text: "Delete").click
      loading.wait_while_present
      retVal = true
    else
      puts "delete not enabled for activity offering code: #{code}"
    end
    retVal
  end

  def select_aos(code_list)
    for code in code_list
      if target_row(code).link(text: "Delete").exists?
        target_row(code).checkbox.set
      end
    end
  end

  def codes_list
    codes = []
    activity_offering_results_table.rows.each { |row| codes << row[AO_CODE].text }
    codes.delete_if { |code| code == "CODE" }
    codes.delete_if { |code| code.strip == "" }
    codes
  end

end