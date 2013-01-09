class ViewRegistrationGroups < BasePage

  wrapper_elements
  frame_element

  expected_element :cluster_name_element

  element(:cluster_name_element) { |b| b.frm.div(id: "registrationGroupsPerCluster_line0_disclosureContent").span() }
  action(:close) { |b| b.frm.div(title: "Close").click; b.loading.wait_while_present }

  element(:page_validation_list) { |b| b.frm.div(id: "registrationGroupsPerCluster_line0").ul(class: "uif-validationMessagesList") }

  def get_error_msgs()
    msg_list = []
    page_validation_list.lis(class:  "uif-errorMessageItem").each do |li|
      msg_list <<  li.text()
    end
    msg_list.to_s
  end

  def get_warning_msgs()
    msg_list = []
    page_validation_list.lis(class:  "uif-warningMessageItem").each do |li|
      msg_list <<  li.text()
    end
    msg_list.to_s
  end

  element(:reg_groups_table) { |b| b.frm.div(id: "registrationGroupsPerCluster_line0").div(class: "dataTables_wrapper").table() }
  ID_COLUMN = 0
  STATE_COLUMN = 1
  CODE_COLUMN = 2
  STATUS_COLUMN = 3
  TYPE_COLUMN = 4
  MAX_ENR_COLUMN = 5
  DAYS_COLUMN = 6
  ST_TIME_COLUMN = 7
  END_TIME_COLUMN = 8
  BLDG_COLUMN = 9
  ROOM_COLUMN = 10
  INSTRUCTOR_COLUMN = 11

  def target_reg_reg_group_row(rg_id)
    reg_groups_table.row(text: /\b#{rg_id}\b/)
  end

  def reg_group_list
    ids = []
    if reg_groups_table.exists?
      reg_groups_table.rows.each { |row| ids << row[ID_COLUMN].text }
      ids.delete_if { |id| id == "REG GROUP ID" }
      ids.delete_if { |id| id.strip == "" }
    end
    ids
  end

  def invalid_reg_groups?
    invalid = false
    if reg_groups_table.exists?
      reg_groups_table.rows.each do |row|
        if row[STATE_COLUMN].text == "Invalid"
          invalid = true
          break
        end
      end
    end
    invalid
  end

end