class DeliveryLogisticsEdit < ActivityOfferingMaintenanceBase

  expected_element :logistics_div_actual

  element(:add_tba){ |b|b.frm.div(data_label: "TBA").checkbox()}
  element(:add_days) { |b| b.frm.div(data_label: "Days").text_field() }
  element(:add_start_time) { |b| b.frm.div(data_label: "Start Time").text_field() }
  element(:add_start_time_ampm) { |b| b.frm.select(name: "document.newMaintainableObject.dataObject.newScheduleRequest.startTimeAMPM") }
  element(:add_end_time) { |b| b.frm.div(data_label: "End Time").text_field() }
  element(:add_end_time_ampm) { |b| b.frm.select(name: "document.newMaintainableObject.dataObject.newScheduleRequest.endTimeAMPM") }
  element(:add_facility) { |b| b.frm.div(data_label: "Facility").text_field() }
  action(:lookup_facility) { |b| b.frm.div(data_label: "Facility").button().click; b.loading.wait_while_present }
  element(:add_room) { |b| b.frm.div(data_label: "Room").text_field() }
  action(:lookup_room) { |b| b.frm.div(data_label: "Room").button().click; b.loading.wait_while_present }

  action(:facility_features) { |b| b.frm.link(id: "ActivityOffering-DeliveryLogistic-New-Features-Section_toggle").click; b.loading.wait_while_present }
  element(:feature_list){ |b|b.frm.select(id: "featuresList_control")}
  action(:add) { |b| b.frm.div(id: "ActivityOffering-DeliveryLogistic-SchedulePage-New").button(text: "Add").click; b.loading.wait_while_present }
  action(:update_request) { |b| b.frm.div(id: "ActivityOffering-DeliveryLogistic-SchedulePage-New").button(text: "Update Request").click; b.loading.wait_while_present }

  ACTIONS_COLUMN = 7
  def edit_requested_logistics_features(row)
    requested_logistics_table.rows[row].cells[ACTIONS_COLUMN].link(text: "Edit").click
    loading.wait_while_present
  end

  def delete_requested_logistics_features(row)
    requested_logistics_table.rows[row].cells[ACTIONS_COLUMN].link(text: "Delete").click
    loading.wait_while_present
  end

  action(:save_request) { |b| b.frm.div(class: "uif-footer").button(text: "Save Request").click; b.loading.wait_while_present }
  action(:save_and_process_request) { |b| b.frm.div(class: "uif-footer").button(text: "Save and Process Request").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.div(class: "uif-footer").link(text: "Cancel").click; b.loading.wait_while_present }


end