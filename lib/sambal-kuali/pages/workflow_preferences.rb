class WorkflowPreferences < BasePage

  wrapper_elements
  frame_element

  element(:refresh_rate) { |b| b.frm.text_field(:name=>"preferences.refreshRate") }
  element(:page_size) { |p| p.frm.text_field(:name=>"preferences.pageSize") }
  element(:email_notification) { |b| b.frm.select(:name=>"preferences.emailNotification") }
  element(:receive_primary_delegate_emails) { |b| b.frm.checkbox(:name=>"preferences.notifyPrimaryDelegation") }
  element(:receive_secondary_delegate_emails) { |b| b.frm.checkbox(:name=>"preferences.notifySecondaryDelegation") }
  element(:delegator_filter) { |b| b.frm.select(:name=>"preferences.delegatorFilter") }
  element(:primary_delegate_filter) { |b| b.frm.select(:name=>"preferences.primaryDelegateFilter") }
  element(:show_document_type) { |b| b.frm.checkbox(:name=>"preferences.showDocType") }
  element(:show_title) { |b| b.frm.checkbox(:name=>"preferences.showDocTitle") }
  element(:show_actionrequested) { |b| b.frm.checkbox(:name=>"preferences.showActionRequested") }
  element(:show_initiator) { |b| b.frm.checkbox(:name=>"preferences.showInitiator") }
  element(:show_delegator) { |b| b.frm.checkbox(:name=>"preferences.showDelegator") }
  element(:show_date_created) { |b| b.frm.checkbox(:name=>"preferences.showDateCreated") }
  element(:show_date_approved) { |b| b.frm.checkbox(:name=>"preferences.showDateApproved") }
  element(:show_current_route_nodes) { |b| b.frm.checkbox(:name=>"preferences.showCurrentNode") }
  element(:show_workgroup_request) { |b| b.frm.checkbox(:name=>"preferences.showWorkgroupRequest") }
  element(:show_doc_route_status) { |b| b.frm.checkbox(:name=>"preferences.showDocumentStatus") }
  element(:show_app_doc_status) { |b| b.frm.checkbox(:name=>"preferences.showAppDocStatus") }
  element(:show_clear_fyi) { |b| b.frm.checkbox(:name=>"preferences.showClearFyi") }
  element(:show_use_outbox) { |b| b.frm.checkbox(:name=>"preferences.useOutbox") }
  element(:save_el) { |b| b.frm.button(:name=>"methodToCall.save") }
  element(:reset_el) { |b| b.frm.link(:href=>"javascript:document.forms[0].reset()") }
  element(:cancel_el) { |b| b.frm.link(:href=>"ActionList.do") }

  action(:save) { |p| p.save_el.click }
  action(:reset) { |p| p.reset_el.click }
  action(:cancel) { |p| p.cancel_el.click }

end