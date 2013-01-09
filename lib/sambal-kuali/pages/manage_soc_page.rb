class ManageSocPage < BasePage

  expected_element :term_code

  wrapper_elements
  frame_element

  element(:term_code)  { |b| b.frm.text_field(name: "termCode") }
  element(:lock_button)  { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-LockSetButton") }
  element(:final_edit_button)  { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-FinalEditButton") }
  element(:send_to_scheduler_button)  { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-SendToSchedulerButton") }
  element(:publish_button)  { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-PublishButton") }
  element(:close_button)  { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-CloseButton") }

  action(:go_action) { |b| b.frm.button(id: "ManageSOCView-GoButton").click; b.loading.wait_while_present }
  action(:lock_action) { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-LockSetButton").click; b.loading.wait_while_present }
  action(:final_edit_action) { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-FinalEditButton").click; b.loading.wait_while_present }
  action(:send_to_scheduler_action) { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-SendToSchedulerButton").click; b.loading.wait_while_present }
  action(:publish_action) { |b| b.frm.button(id: "ManageSOCView-SchedulingDetails-PublishButton").click; b.loading.wait_while_present }

  element(:lock_popup_div) { |b| b.div(id: "lockConfirmDialog") }
  action(:lock_confirm_action) { |b| b.lock_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:lock_cancel_action) { |b| b.lock_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }

  element(:schedule_popup_div) { |b| b.div(id: "massScheduleConfirmDialog") }
  action(:schedule_confirm_action) { |b| b.schedule_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:schedule_cancel_action) { |b| b.schedule_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }

  element(:final_edit_popup_div) { |b| b.div(id: "finalEditConfirmDialog") }
  action(:final_edit_confirm_action) { |b| b.final_edit_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:final_edit_cancel_action) { |b| b.final_edit_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }

  element(:publish_popup_div) { |b| b.div(id: "massPublishConfirmDialog") }
  action(:publish_confirm_action) { |b| b.publish_popup_div.checkbox(index: 0).click; b.loading.wait_while_present }
  action(:publish_cancel_action) { |b| b.publish_popup_div.checkbox(index: 1).click; b.loading.wait_while_present }

  element(:soc_status) { |b| b.div(id: "socStatus").span(index: 2).text }
  element(:soc_scheduling_status) { |b| b.div(id: "socSchedulingStatus").span(index: 2).text }
  element(:soc_publishing_status) { |b| b.div(id: "socPublishingStatus").span(index: 2).text }

end