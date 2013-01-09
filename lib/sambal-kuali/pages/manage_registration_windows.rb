class ManageRegistrationWindows < BasePage

  wrapper_elements
  frame_element
  validation_elements

  element(:term_type) { |b| b.frm.select(name: "termType") }
  element(:year) { |b| b.frm.text_field(name: "termYear") }

  action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!

end

class RegistrationWindowsTermLookup < RegistrationWindowsBase

  registration_window_lookup_elements

  expected_element :term_type

  def search_by_term_and_year
    term_type.select 'Spring Term'
    year.set '2012'
    search
    #page.loading.wait_while_present
  end

end

class RegistrationWindowsPeriodLookup < RegistrationWindowsBase

  registration_window_period_lookup_elements

  expected_element :period_id

  def show_windows_by_period
    period_id.select 'All Registration Periods for this Term'
    show
  end

end

class RegistrationWindowsCreate < RegistrationWindowsBase

  expected_element  :window_collection_table

  element(:window_collection_div) { |b| b.frm.div(id: "addRegistrationWindowCollection_disclosureContent") }
  element(:window_collection_table) { |b| b.window_collection_div.table() }

  COLUMN_PERIOD_NAME = 0
  COLUMN_WINDOW_NAME = 1
  COLUMN_STUDENT_GROUP = 2
  COLUMN_START_DATE = 3
  COLUMN_START_TIME = 4
  COLUMN_START_TIME_AM_PM = 5
  COLUMN_END_DATE = 6
  COLUMN_END_TIME = 7
  COLUMN_END_TIME_AM_PM = 8
  COLUMN_METHOD = 9
  COLUMN_MAX = 10
  COLUMN_RULE = 11
  COLUMN_ACTION = 12
  COLUMN_ASSIGN_STUDENTS = 12
  COLUMN_BREAK_APPOINTMENTS = 12

  def get_target_row(window_name, period_key)
    window_collection_table.rows.each do |r|
      if (r.cells[COLUMN_WINDOW_NAME].text.strip.eql?(window_name) && r.cells[COLUMN_PERIOD_NAME].text.strip.eql?(period_key))
        return r
      end
    end
  end

  element(:appointment_window_info_name) { |b| b.window_collection_table.rows[1].cells[COLUMN_WINDOW_NAME].text_field() }
  element(:assigned_population_name) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].assignedPopulationName") }
  #element(:assigned_population_name) { |b| b.window_collection_table.rows[1].cells[COLUMN_PERIOD_NAME].select }
  element(:period_key) { |b| b.window_collection_table.rows[1].cells[COLUMN_PERIOD_NAME].select }
  element(:start_date) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].startDate") }
  element(:start_time) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].startTime") }
  element(:start_time_am_pm) { |b| b.frm.select(name: "newCollectionLines['appointmentWindows'].startTimeAmPm") }
  element(:end_date) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].endDate") }
  element(:end_time) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].endTime") }
  element(:end_time_am_pm) { |b| b.frm.select(name: "newCollectionLines['appointmentWindows'].endTimeAmPm") }
  element(:window_type_key) { |b| b.frm.select(name: "newCollectionLines['appointmentWindows'].windowTypeKey") }
  element(:slot_rule_enum_type) { |b| b.frm.select(name: "newCollectionLines['appointmentWindows'].slotRuleEnumType") }
  element(:max_appointments_per_slot) { |b| b.frm.text_field(name: "newCollectionLines['appointmentWindows'].appointmentWindowInfo.maxAppointmentsPerSlot") }
  element(:page_validation_header) { |b| b.h3(id: "pageValidationHeader") }
  #element(:date_ranges) { |b| b.div(id: "KS-RegistrationWindows-PeriodSection") }
  element(:date_ranges) { |b| b.span(id: "periodDetails_span") }
  #value(:date_ranges) { |b| b.div(id: "KS-RegistrationWindows-PeriodSection").span().text }
  element(:add_button_element) { |b| b.frm.button(text: "add") }
  action(:add) { |b| b.frm.button(text: "add").click; b.adding_line.wait_while_present }
  action(:delete) { |b| b.frm.button(text: "X").click; b.loading.wait_while_present }
  action(:assign_students) { |b| b.frm.button(text: "Assign Students").click; b.loading.wait_while_present }
  action(:break_appointments) { |b| b.frm.button(text: "Break Appointments").click; b.loading.wait_while_present }
  action(:appointment_detail) { |b| b.frm.a(id: "u206_line0").click; b.loading.wait_while_present }
  action(:save) { |b| b.from.button(text: "Save").click; b.loading.wait_while_present }


  element(:yes_label) { |b| b.frm.span(text: "Yes") }
  element(:delete_popup_div) { |b| b.div(id: "KS-RegistrationWindowsManagement-ConfirmDelete-Dialog") }
  action(:confirm_delete) { |b| b.delete_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:cancel_delete) { |b| b.delete_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }

  element(:break_appointments_popup_div) { |b| b.div(id: "KS-RegistrationWindowsManagement-ConfirmBreakAppointments-Dialog") }
  action(:confirm_break_appointments) { |b| b.break_appointments_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:cancel_break_appointments) { |b| b.break_appointments_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }
  element(:adding_line) { |b| b.frm.image(alt: "Adding Line...") }

  def results_list_by_window_name()
    names = []
    window_collection_table.wait_until_present
    window_collection_table.rows.each { |row| names << row[COLUMN_WINDOW_NAME].text }
    names.delete_if { |name| name == "" }
    names.delete_if { |name| name == "Window" }
    names
  end

  def is_window_created(window_name, period_key)
    row = get_target_row(window_name, period_key)
    if row.class.name.eql? ("Watir::TableRow")
      return true
    end
    return false
  end

  def is_window_deleted(window_name, period_key)
    row = get_target_row(window_name, period_key)
    if row.class.name.eql? ("Watir::TableRow")
      return false
    end
    return true
  end

  def are_window_fields_editable(window_name, period_key)
    return are_editable_window_fields_editable(window_name, period_key) || are_non_editable_window_fields_editable(window_name, period_key)
  end

  def are_editable_window_fields_editable(window_name, period_key)
    puts "Checking to see if the editable fields are editable for #{window_name} in period #{period_key}"
    ret_value = false;
    row = get_target_row(window_name, period_key)
    ret_value = ret_value || row.cells[COLUMN_START_TIME_AM_PM].select.exists?
    ret_value = ret_value || row.cells[COLUMN_END_TIME_AM_PM].select.exists?
    #ret_value = ret_value || row.cells[COLUMN_RULE].select.exists?
    if row.cells[COLUMN_START_DATE].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_START_DATE].text_field.type.eql?("text")
    end
    if row.cells[COLUMN_START_TIME].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_START_TIME].text_field.type.eql?("text")
    end
    if row.cells[COLUMN_END_DATE].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_END_DATE].text_field.type.eql?("text")
    end
    if row.cells[COLUMN_END_TIME].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_END_TIME].text_field.type.eql?("text")
    end

    method = row.cells[COLUMN_METHOD].span.text

    if method.strip.eql?(RegistrationWindowsConstants::METHOD_MAX_SLOTTED_WINDOW) || method.strip.eql?(RegistrationWindowsConstants::METHOD_UNIFORM_SLOTTED_WINDOW)
      ret_value = ret_value || row.cells[COLUMN_RULE].select.exists?
    end

    if method.strip.eql?(RegistrationWindowsConstants::METHOD_MAX_SLOTTED_WINDOW)
      if row.cells[COLUMN_MAX].text_field.exists?
        ret_value = ret_value || row.cells[COLUMN_MAX].text_field.type.eql?("text")
      end
    end

    return ret_value
  end

  def is_anchor(window_name, period_key)
    puts "Checking to see if the row contains an anchor for #{window_name} in period #{period_key}"
    row = get_target_row(window_name, period_key)
    return row.cells[COLUMN_WINDOW_NAME].a.exists?
  end

  def are_non_editable_window_fields_editable(window_name, period_key)
    puts "Checking to see if the non-editable fields are editable for #{window_name} in period #{period_key}"
    ret_value = false;
    row = get_target_row(window_name, period_key)
    ret_value = ret_value || row.cells[COLUMN_PERIOD_NAME].select.exists?
    ret_value = ret_value || row.cells[COLUMN_METHOD].select.exists?
    if row.cells[COLUMN_WINDOW_NAME].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_WINDOW_NAME].text_field.type.eql?("text")
    end
    if row.cells[COLUMN_STUDENT_GROUP].text_field.exists?
      ret_value = ret_value || row.cells[COLUMN_STUDENT_GROUP].text_field.type.eql?("text")
    end

    return ret_value
  end

  def assign_students(window_name, period_key)
    puts "Assigning Students for #{window_name} in period #{period_key}"
    # ToDo add period_key to the get_target_row
    row = get_target_row(window_name, period_key)
    row.cells[COLUMN_ASSIGN_STUDENTS].button(text: "Assign Students").click
    loading.wait_while_present(60)
    while true
      begin
        sleep 1
        wait_until { window_collection_table.exists? }
        break
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        puts "rescued"
      end
    end
  end

  def break_appointments(window_name, period_key)
    puts "Breaking Appointments for #{window_name} in period #{period_key}"
    # ToDo add period_key to the get_target_row
    row = get_target_row(window_name, period_key)
    row.cells[COLUMN_BREAK_APPOINTMENTS].button(text: "Break Appointments").click
    loading.wait_while_present(60)
    while true
      begin
        sleep 1
        wait_until { window_collection_table.exists? }
        break
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        puts "rescued"
      end
    end
  end

  def is_window_name_unique(window_name, period_key)
    count = 0
    window_collection_table.rows.each do |r|
      if (r.cells[COLUMN_WINDOW_NAME].text.strip.eql?(window_name) && r.cells[COLUMN_PERIOD_NAME].text.strip.eql?(period_key))
        count = count + 1
      end
      if (count > 1)
        return false
      end
    end
    return true
  end

  def exists_error_message
    if (page_validation_header.exists?)
      return true
    end
    return false
  end

  def does_window_contain_elements(window_name, period_key)
    row = get_target_row(window_name, period_key)
    return row.cells[COLUMN_ACTION].button(text: "X").visible? && row.cells[COLUMN_ACTION].button(text: "Assign Students").visible?
  end

  def remove(window_name, period_key)
    get_target_row(window_name, period_key).cells[COLUMN_ACTION].button(text: "X").click
    loading.wait_while_present
  end

  def get_period(window_name, period_key)
    row = get_target_row(window_name, period_key)
    if (row.class.name.eql?("Watir::TableRow"))
      span = row.cells[COLUMN_PERIOD_NAME].span
      if (span.exists?)
        return span.text.strip
      end
    end
    return ''
  end

  def edit(window_name, period_key, start_date, start_time, start_time_am_pm, end_date, end_time, end_time_am_pm)
    row = get_target_row(window_name, period_key)
    row.cells[COLUMN_START_DATE].text_field.set start_date
    row.cells[COLUMN_START_TIME].text_field.set start_time
    row.cells[COLUMN_START_TIME_AM_PM].select.select start_time_am_pm
    row.cells[COLUMN_END_DATE].text_field.set end_date
    row.cells[COLUMN_END_TIME].text_field.set end_time
    row.cells[COLUMN_END_TIME_AM_PM].select.select end_time_am_pm

    form.button(text: "Save").click
    loading.wait_while_present
    #sleep(5)

  end

  def validate_fields()
    puts "Verifying the Registration Windows fields"
    ret_value = true

    return_value = return_value && period_key.exists?
    return_value = return_value && appointment_window_info_name.exists?
    return_value = return_value && assigned_population_name.exists?
    return_value = return_value && start_date.exists?
    return_value = return_value && start_time.exists?
    return_value = return_value && start_time_am_pm.exists?
    return_value = return_value && end_date.exists?
    return_value = return_value && end_time.exists?
    return_value = return_value && end_time_am_pm.exists?
    return_value = return_value && window_type_key.exists?
    return_value = return_value && slot_rule_enum_type.exists?
    return_value = return_value && add.exists?
    return ret_value
  end

  def validate_dynamic_fields(slot_allocation_method)
    puts "Verifying Dynamic fields for #{slot_allocation_method}"

    case (slot_allocation_method)
      when RegistrationWindowsConstants::METHOD_ONE_SLOT_PER_WINDOW
        return (!slot_rule_enum_type.exists? && !max_appointments_per_slot.exists?)
      when RegistrationWindowsConstants::METHOD_MAX_SLOTTED_WINDOW
        return (slot_rule_enum_type.exists? && max_appointments_per_slot.exists?)
      when RegistrationWindowsConstants::METHOD_UNIFORM_SLOTTED_WINDOW
        return (slot_rule_enum_type.exists? && !max_appointments_per_slot.exists?)
      else
        raise "The Registration Windows Slot Allocation Method must be one of the following values:\n'#{RegistrationWindowsConstants::METHOD_ONE_SLOT_PER_WINDOW}', '#{RegistrationWindowsConstants::METHOD_MAX_SLOTTED_WINDOW}', '#{RegistrationWindowsConstants::METHOD_UNIFORM_SLOTTED_WINDOW}'.\nPlease update your script"
    end
    #return return_value
  end

  def validate_values(window_name, period_key, start_date, start_time, start_time_am_pm, end_date, end_time, end_time_am_pm)
    ret_value = true
    row = get_target_row(window_name, period_key)
    return_value = return_value && row.cells[COLUMN_START_DATE].text_field.value.eql?(start_date)
    return_value = return_value && row.cells[COLUMN_START_TIME].text_field.value.eql?(start_time)
    return_value = return_value && row.cells[COLUMN_START_TIME_AM_PM].select.selected_options.first.text.eql?(start_time_am_pm)
    return_value = return_value && row.cells[COLUMN_END_DATE].text_field.value.eql?(end_date)
    return_value = return_value && row.cells[COLUMN_END_TIME].text_field.value.eql?(end_time)
    return_value = return_value && row.cells[COLUMN_END_TIME_AM_PM].select.selected_options.first.text.eql?(end_time_am_pm)
    return ret_value
  end

  def get_row_object(window_name, period_key)
    row_object = {}
    row = get_target_row(window_name, period_key)
    row_object[:start_date] = row.cells[COLUMN_START_DATE].text_field.value
    row_object[:start_time] = row.cells[COLUMN_START_TIME].text_field.value
    row_object[:start_time_am_pm] = row.cells[COLUMN_START_TIME_AM_PM].select.selected_options.first.text
    row_object[:end_date] = row.cells[COLUMN_END_DATE].text_field.value
    row_object[:end_time] = row.cells[COLUMN_END_TIME].text_field.value
    row_object[:end_time_am_pm] = row.cells[COLUMN_END_TIME_AM_PM].select.selected_options.first.text

    if (row.cells[COLUMN_MAX].text_field.exists? && row.cells[COLUMN_MAX].text_field.type.eql?("text"))
      row_object[:max_appointments_per_slot] = row.cells[COLUMN_MAX].text_field.value
    end
    if (row.cells[COLUMN_RULE].select.exists?)
      row_object[:slot_rule_enum_type] = row.cells[COLUMN_RULE].select.selected_options.first.text
    end

    return row_object
  end

end