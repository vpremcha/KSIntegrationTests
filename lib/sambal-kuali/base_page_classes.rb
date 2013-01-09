class PopulationsBase < BasePage

  wrapper_elements
  element(:child_populations_table) { |b| b.frm.div(id: "populations_table").table() }

  class << self

    def population_lookup_elements
      element(:keyword) { |b| b.frm.text_field(name: "lookupCriteria[keyword]") }
      element(:results_table) { |b| b.frm.div(id: "population_lookup").table(index: 0) }

      element(:active) { |b| b.frm.radio(value: "kuali.population.population.state.active") }
      element(:inactive) { |b| b.frm.radio(value: "kuali.population.population.state.inactive") }
      element(:both) { |b| b.frm.radio(value: "both") }
    end

    def population_attribute_elements
      element(:name) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.name") }
      element(:description) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.populationInfo.descr.plain") }
      element(:rule) { |b| b.frm.select(name: "document.newMaintainableObject.dataObject.populationRuleInfo.agendaIds[0]") }
      element(:child_population) { |b| b.frm.text_field(name: "newCollectionLines['document.newMaintainableObject.dataObject.childPopulations'].name") }
      element(:reference_population) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.referencePopulation.name") }

      action(:lookup_population) { |b| b.frm.link(id: "lookup_searchPopulation_add").click; b.loading.wait_while_present }
      action(:lookup_ref_population) { |b| b.frm.link(id: "lookup_searchRefPopulation").click; b.loading.wait_while_present }
      action(:add) { |b| b.child_populations_table.button(text: "add").click; b.loading.wait_while_present; sleep 1.5 }
    end

    def population_view_elements
      element(:name_label) { |b| b.frm.div(data_label: "Name").label }
      value(:name) { |b| b.frm.div(data_label: "Name").span(index: 1).text }
      value(:description) { |b| b.frm.div(data_label: "Description").span(index: 1).text }
      value(:state) { |b| b.frm.div(data_label: "State").span(index: 1).text }
      value(:rule) { |b| b.frm.div(data_label: "Rule").span(index: 2).text }
      value(:operation) { |b| b.frm.div(data_label: "Operation").span(index: 2).text }
      value(:reference_population) { |b| b.frm.div(data_label: "Reference Population").span(index: 1).text }
    end

  end

end

module PopulationsSearch

  # Results Table Columns...
  ACTION = 0
  POPULATION_NAME = 1
  POPULATION_DESCRIPTION = 2
  POPULATION_TYPE = 3
  POPULATION_STATE = 4

  # Clicks the 'return value' link for the named row
  def return_value(name)
    target_row(name).wait_until_present
    target_row(name).link(text: "return value").wait_until_present
    begin
      target_row(name).link(text: "return value").click
    rescue Timeout::Error => e
      puts "rescued target_row(name).link(text: return value).click"
    end
    loading.wait_while_present
  end

  # Clicks the 'edit' link for the named item in the results table
  def edit(name)
    target_row(name).wait_until_present
    target_row(name).link(text: "edit").click
    loading.wait_while_present
    sleep 0.5 # Needed because the text doesn't immediately appear in the Populations field for some reason
  end

  # Clicks the link for the named item in the results table
  def view(name)
    target_row(name).wait_until_present
    results_table.link(text: name).click
    loading.wait_while_present
  end

  # Returns the status of the named item from the results
  # table. Note that this method assumes that the specified
  # item is actually listed in the results table.
  def status(name)
    target_row(name).wait_until_present
    target_row(name)[POPULATION_STATE].text
  end

  # Returns an array containing the names of the items returned in the search
  def results_list
    names = []
    results_table.wait_until_present
    results_table.rows.each { |row| names << row[POPULATION_NAME].text }
    names.delete_if { |name| name == "" }
    names.delete_if { |name| name == "Name" }
    names
  end

  alias results_names results_list

  def results_descriptions
    descriptions = []
    results_table.wait_until_present
    results_table.rows.each { |row| descriptions << row[POPULATION_DESCRIPTION].text }
    descriptions.delete_if { |description| description == "" }
    descriptions
  end

  def results_states
    states = []
    results_table.wait_until_present
    results_table.rows.each { |row| states << row[POPULATION_STATE].text }
    states.delete_if { |state| state == "" }
    states.delete_if { |state| state == "State" }
    states
  end

  def search_for_random_pop(pops_used_list=[]) #checks to make sure pop not already used
    names = []
    on ActivePopulationLookup do |page|
      page.keyword.wait_until_present
      page.search
      no_of_full_pages =  [(page.no_of_entries.to_i/10).to_i,5].min
      page.change_results_page(1+rand(no_of_full_pages))
      names = page.results_list
    end
    #next line ensures population is not used twice
    names = names - pops_used_list
    names[1+rand(names.length-1)]
  end

  private

  def target_row(name)
    results_table.rows.each do |r|
      if (r.cells[POPULATION_NAME].text =~ /#{name}/)
        return r
      end
    end
  end

end

module PopulationEdit

  def child_populations
    names = []
    child_populations_table.divs(class: "uif-field").each { |div| names << div.text }
    names.delete_if { |name| name == "" || name == "delete" || name == "add" }
  end

  def remove_population(name)
    child_populations_table.row(text: /#{name}/).button(index: 0).click
    loading.wait_while_present
    wait_until { description.enabled? }
    sleep 2 #FIXME - Needed because otherwise the automation causes an application error
  end

end

class HoldBase < BasePage

  class << self
    def hold_elements
      element(:hold_name) { |b| b.frm.text_field(name: "name") }
      element(:category_name) { |b| b.frm.select(name: "typeKey") }
      element(:phrase) { |b| b.frm.text_field(name: "descr") }
      element(:owning_organization) { |b| b.frm.text_field(name: "id") }
      action(:lookup_owning_org) { |b| b.frm.button(title: "Search Field").click; b.loading.wait_while_present }
    end
  end
end

class OrganizationBase < BasePage

  class << self
    def organization_elements
      element(:short_name) { |b| b.frm.text_field(name: "lookupCriteria[shortName]") }
      element(:long_name) { |b| b.frm.text_field(name: "lookupCriteria[longName]") }
    end
  end

end

class HolidayBase < BasePage

  element(:holiday_type) { |b| b.frm.select(name: "newCollectionLines['holidays'].typeKey") }
  element(:holiday_start_date) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].startDate") }
  element(:holiday_start_time) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].startTime") }
  element(:holiday_start_meridian) { |b| b.frm.select(name: "newCollectionLines['holidays'].startTimeAmPm") }
  element(:holiday_end_date) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].endDate") }
  element(:holiday_end_time) { |b| b.frm.text_field(name: "newCollectionLines['holidays'].endTime") }
  element(:holiday_end_meridian) { |b| b.frm.select(name: "newCollectionLines['holidays'].endTimeAmPm") }
  element(:all_day) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].allDay") }
  element(:date_range) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].dateRange") }
  element(:instructional) { |b| b.frm.checkbox(name: "newCollectionLines['holidays'].instructional") }
  element(:add_button) { |b| b.frm.button(id: /u\d+_add/) }

  element(:make_official_button) { |b| b.frm.button(text: "Make Official") }

  action(:make_official) { |b| b.make_official_button.click; b.loading.wait_while_present }
  action(:save) { |b| b.frm.button(text: "Save").click; b.loading.wait_while_present }

end

module Holidays

  def add_all_day_holiday(type, date, inst=false)
    wait_until { holiday_type.enabled? }
    holiday_type.select type
    holiday_start_date.set date
    all_day.set unless all_day.set?
    date_range.clear if date_range.set?
    loading.wait_while_present
    instruct(inst)
    add_button.click
    loading.wait_while_present
  end

  def add_date_range_holiday(type, start_date, end_date, inst=false)
    wait_until { holiday_type.enabled? }
    holiday_type.select type
    holiday_start_date.set start_date
    all_day.set unless all_day.set?
    date_range.set unless date_range.set?
    loading.wait_while_present
    begin
      wait_until { holiday_end_date.enabled? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 2
    end
    holiday_end_date.set end_date
    instruct(inst)
    add_button.click
    loading.wait_while_present
  end

  def add_partial_day_holiday(type, start_date, start_time, start_meridian, end_time, end_meridian, inst=false)
    wait_until { holiday_type.enabled? }
    holiday_type.select type
    holiday_start_date.set start_date
    all_day.clear if all_day.set?
    date_range.clear if date_range.set?
    loading.wait_while_present
    begin
      wait_until { holiday_end_time.enabled? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 2
    end
    holiday_start_time.set start_time
    holiday_start_meridian.select start_meridian
    holiday_end_time.set end_time
    holiday_end_meridian.select end_meridian
    instruct(inst)
    add_button.click
    loading.wait_while_present
  end

  def add_partial_range_holiday(type, start_date, start_time, start_meridian, end_date, end_time, end_meridian, inst=false)
    wait_until { holiday_type.enabled? }
    holiday_type.select type
    holiday_start_date.set start_date
    all_day.clear if all_day.set?
    date_range.set unless date_range.set?
    loading.wait_while_present
    begin
      wait_until { holiday_end_date.enabled? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 2
    end
    holiday_start_time.set start_time
    holiday_start_meridian.select start_meridian
    holiday_end_date.set end_date
    holiday_end_time.set end_time
    holiday_end_meridian.select end_meridian
    instruct(inst)
    add_button.click
    loading.wait_while_present
  end

  def delete_holiday(holiday_type)
    target_row(holiday_type).button(text: "delete").click
    loading.wait_while_present
  end

  def edit_start_date(holiday_type, date)
    target_row(holiday_type).text_field(name: /startDate/).set date
  end

  def edit_start_time(holiday_type, time, meridian)
    target_row(holiday_type).checkbox(name: /allDay/).clear if target_row(holiday_type).checkbox(name: /allDay/).set?
    target_row(holiday_type).text_field(name: /startTime\d/).set time
    target_row(holiday_type).text_field(name: /startTimeAmPm/).set meridian
  end

  def edit_end_time(holiday_type, time, meridian)
    target_row(holiday_type).checkbox(name: /dateRange/).set unless target_row(holiday_type).checkbox(name: /dateRange/).set?
    target_row(holiday_type).text_field(name: /endTime\d/).set time
    target_row(holiday_type).text_field(name: /endTimeAmPm/).set meridian
  end

  def toggle_all_day(holiday_type)
    if target_row(holiday_type).checkbox(name: /allDay/).set?
      target_row(holiday_type).checkbox(name: /allDay/).clear
    else
      target_row(holiday_type).checkbox(name: /allDay/).set
    end
  end

  def toggle_range(holiday_type)
    if target_row(holiday_type).checkbox(name: /dateRange/).set?
      target_row(holiday_type).checkbox(name: /dateRange/).clear
    else
      target_row(holiday_type).checkbox(name: /dateRange/).set
    end
  end

  def toggle_instructional(holiday_type)
    if target_row(holiday_type).checkbox(name: /instructional/).set?
      target_row(holiday_type).checkbox(name: /instructional/).clear
    else
      target_row(holiday_type).checkbox(name: /instructional/).set
    end
  end

  # Returns a random item from the list of holidays
  def select_random_holiday
    holidays = []
    wait_until { holiday_type.enabled? }
    sleep 5
    holiday_type.options.each { |opt| holidays << opt.text }
    holidays.delete_if { |item| item == "Select holiday type" }
    holidays[rand(holidays.length)]
  end

  private

  def target_row(holiday_type)
    holiday_table.row(text: /#{Regexp.escape(holiday_type)}/)
  end

  def instruct(instr)
    if instr
      instructional.set
    else
      instructional.clear
    end
  end

end

class ActivityOfferingMaintenanceBase < BasePage

  wrapper_elements
  validation_elements
  frame_element

  element(:logistics_div_actual) { |b| b.frm.div(id: /^ActivityOffering-DeliveryLogistic.*-Actuals$/) }
  action(:revise_logistics) { |b| b.logistics_div_actual.link(text: "Revise").click; b.loading.wait_while_present }

  element(:actual_logistics_table) { |b| b.logistics_div_actual.table() }

  TBA_COLUMN = 0
  DAYS_COLUMN = 1
  ST_TIME_COLUMN = 2
  END_TIME_COLUMN = 3
  FACILITY_COLUMN = 4
  ROOM_COLUMN = 5
  FEATURES_COLUMN = 6

  def self.adl_table_accessor_maker(method_name, column)
    define_method method_name.to_s do |row|
      row.cells[column].text()
    end
  end

  adl_table_accessor_maker :get_actual_logistics_tba, TBA_COLUMN
  adl_table_accessor_maker :get_actual_logistics_days, DAYS_COLUMN
  adl_table_accessor_maker :get_actual_logistics_start_time, ST_TIME_COLUMN
  adl_table_accessor_maker :get_actual_logistics_end_time, END_TIME_COLUMN
  adl_table_accessor_maker :get_actual_logistics_facility, FACILITY_COLUMN
  adl_table_accessor_maker :get_actual_logistics_room, ROOM_COLUMN
  adl_table_accessor_maker :get_actual_logistics_features, FEATURES_COLUMN

  element(:logistics_div_requested) { |b| b.frm.div(id: "ActivityOffering-DeliveryLogistic-SchedulePage-Requested") }
  element(:requested_logistics_table) { |b| b.logistics_div_requested.table() }

  def self.rdl_table_accessor_maker(method_name, column)
    define_method method_name.to_s do |row|
      requested_logistics_table.rows[row].cells[column].text()
    end
  end

  rdl_table_accessor_maker :get_requested_logistics_tba, TBA_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_days, DAYS_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_start_time, ST_TIME_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_end_time, END_TIME_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_facility, FACILITY_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_room, ROOM_COLUMN
  rdl_table_accessor_maker :get_requested_logistics_features, FEATURES_COLUMN

  element(:personnel_table) { |b| b.frm.div(id: "ao-personnelgroup").table() }
  ID_COLUMN = 0
  PERS_NAME_COLUMN = 1
  AFFILIATION_COLUMN = 2
  INST_EFFORT_COLUMN = 3

  def get_affiliation(id)
    target_person_row(id).cells[AFFILIATION_COLUMN].text
  end

  element(:seat_pools_div) { |b| b.frm.div(id: "ao-seatpoolgroup") }
  element(:seat_pools_table) { |b| b.seat_pools_div.table() }

  PRIORITY_COLUMN = 0
  SEATS_COLUMN = 1
  PERCENT_COLUMN = 2
  POP_NAME_COLUMN = 3
  EXP_MILESTONE_COLUMN = 4

  def pool_percentage(pop_name)
    target_pool_row(pop_name).div(id: /seatLimitPercent_line/).text
  end

  value(:seat_pool_count) { |b| b.frm.div(data_label: "Seat Pools").span(index: 2).text }
  value(:seats_remaining_span) { |b| b.frm.div(id: "seatsRemaining").span(index: 2) }
  value(:seats_remaining) { |b| b.seats_remaining_span.text }
  value(:percent_seats_remaining) { |b| b.seats_remaining_span.text[/\d+(?=%)/] }
  value(:seat_count_remaining) { |b| b.seats_remaining_span.text[/\d+(?=.S)/] }
  value(:max_enrollment_count) { |b| b.frm.div(id: "seatsRemaining").text[/\d+(?=\))/] }

  private

  def target_person_row(id)
    personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
  end

  def target_pool_row(pop_name)
    seat_pools_table.row(text: /#{Regexp.escape(pop_name)}/)
  end
end

class RegistrationWindowsBase < BasePage

  wrapper_elements
  validation_elements
  frame_element
  #element(:child_populations_table) { |b| b.frm.div(id: "populations_table").table() }

  class << self


    def registration_window_lookup_elements
      element(:term_type) { |b| b.frm.select(name: "termType") }
      element(:year) { |b| b.frm.text_field(name: "termYear") }
      action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!
    end

    def registration_window_period_lookup_elements
      element(:period_id) { |b| b.frm.select(name: "periodId") }
      action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present }
    end

  end

end

module RegistrationWindowsConstants
  START_DATES_MAP_NAME = 'start_dates_map'
  END_DATES_MAP_NAME = 'end_dates_map'
  DATE_WITHIN = "DATE_WITHIN"
  DATE_WITHIN_REVERSE = "WITHIN_REVERSE"
  DATE_BEFORE = "BEFORE"
  DATE_AFTER = "AFTER"
  DATE_BOUND_START = "START"
  DATE_BOUND_END = "END"
  METHOD_ONE_SLOT_PER_WINDOW = "One Slot per Window"
  METHOD_MAX_SLOTTED_WINDOW = "Max Slotted Window"
  METHOD_UNIFORM_SLOTTED_WINDOW = "Uniform Slotted Window"
end