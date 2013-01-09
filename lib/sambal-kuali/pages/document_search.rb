class DocumentSearch < BasePage

  wrapper_elements
  frame_element

  element(:search_toggle) { |b| b.frm.button(name: "toggleAdvancedSearch") }
  element(:user_toggle) { |b| b.frm.button(name: "toggleSuperUserSearch") }
  element(:searches) { |b| b.frm.select(name: "savedSearchToLoadAndExecute") }

  action(:basic_search) { |p| p.search_toggle.click }
  action(:detailed_search) { |p| p.search_toggle.click }
  action(:clear_saved_searches) { |b| b.frm.button(name: "resetSavedSearch").click }

  element(:document_type) { |b| b.frm.text_field(name: "documentTypeName") }
  element(:initiator) { |b| b.frm.text_field(name: "initiatorPrincipalName") }
  element(:approver) { |b| b.frm.text_field(name: "approverPrincipalName") }
  element(:viewer) { |b| b.frm.text_field(name: "viewerPrincipalName") }
  element(:application_document_id) { |b| b.frm.text_field(name: "applicationDocumentId") }
  element(:document_id) { |b| b.frm.text_field(name: "documentId") }
  element(:document_status) { |b| b.frm.select(name: "statusCode") }
  element(:date_created_from) { |b| b.frm.text_field(name: "rangeLowerBoundKeyPrefix_dateCreated") }
  element(:date_created_to) { |b| b.frm.text_field(name: "dateCreated") }
  element(:date_approved_from) { |b| b.frm.text_field(name: "rangeLowerBoundKeyPrefix_dateApproved") }
  element(:date_approved_to) { |b| b.frm.text_field(name: "dateApproved") }
  element(:date_last_modified_from) { |b| b.frm.text_field(name: "rangeLowerBoundKeyPrefix_dateLastModified") }
  element(:date_last_modified_to) { |b| b.frm.text_field(name: "dateLastModified") }
  element(:date_finalized_from) { |b| b.frm.text_field(name: "rangeLowerBoundKeyPrefix_dateFinalized") }
  element(:date_finalized_to) { |b| b.frm.text_field(name: "dateFinalized") }
  element(:title) { |b| b.frm.text_field(name: "title") }
  element(:name_this_search) { |b| b.frm.text_field(name: "saveName") }

  action(:search) { |b| b.frm.button(name: "methodToCall.search").click }
  action(:clear) { |b| b.frm.button(name: "methodToCall.clearValues").click }

  element(:results_table) { |b| b.frm.table(id: "row", class: "datatable-100") }

end