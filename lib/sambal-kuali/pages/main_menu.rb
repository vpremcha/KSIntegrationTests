class MainMenu < BasePage

  page_url "#{$test_site}/portal.do?selectedTab=main"
  expected_title /Kuali Portal Index/
  expected_element :enrollment_home_link

  wrapper_elements

  element(:enrollment_home_link) { |b| b.link(text: "Enrollment Home") }

  action(:enrollment_home) { |b| b.enrollment_home_link.click }
  action(:kuali_student_home) { |b| b.link(text: "Kuali Student Home").click }
  action(:curriculum_management) { |b| b.link(text: "Curriculum Management").click }
  action(:organization_management) { |b| b.link(text: "Organization Management").click }
  action(:perform_rollover) { |b| b.link(text: "Perform Rollover").click }
  action(:rollover_details) { |b| b.link(text: "Rollover Details").click }
  action(:manage_course_offerings) { |b| b.link(text: "Manage Course Offerings").click }
  action(:delete_target_term) { |b| b.link(text: "Delete Target Term").click }
  action(:release_to_departments) { |b| b.link(text: "Release to Departments").click }
  action(:activity_offering_lookup) { |b| b.link(text: "Activity Offering Lookup").click }
  action(:activity_offering_lookup2) { |b| b.link(text: "Activity Offering Lookup 2").click }
  action(:course_offering_info_lookup) { |b| b.link(title: "CourseOfferingInfo Lookup").click }
  action(:enrollment_fee_info_lookup) { |b| b.link(title: "Enrollment Fee Info Lookup and Inquiry").click }
  action(:format_offering_info_lookup) { |b| b.link(title: "Format Offering Info Lookup").click }
  action(:socrolloverresultinfo_lookup) { |b| b.link(title: "SocRolloverResultInfo Lookup").click }
  action(:socrolloverresultiteminfo_lookup) { |b| b.link(title: "SocRolloverResultItemInfo Lookup").click }
  action(:term_info_lookup) { |b| b.link(title: "Term Info Lookup").click }
  action(:course_info_lookup) { |b| b.link(title: "Course Info Lookup").click }
  action(:new_course_offering) { |b| b.link(title: "Course Offering (New)").click }
  action(:edit_course_offering) { |b| b.link(title: "Course Offering (Edit)").click }
  action(:new_enrollment_fee_info) { |b| b.link(title: "Enrollment Fee Info (New)").click }
  action(:new_format_offering_info) { |b| b.link(title: "Format Offering Info (New)").click }
  action(:manage_registration_windows) { |b| b.link(title: "Manage Registration Windows And Appointments").click }
  action(:registration_windows_lookup) { |b| b.link(title: "Registration Windows Lookup and Inquiry ").click }
  action(:calendar_search)  { |b| b.link(title: "Calendar Search").click }
  action(:create_holiday_calendar) { |b| b.link(title: "Create Holiday Calendar").click }
  action(:holiday_calendar_lookup) { |b| b.link(title: "Holiday Calendar Lookup").click }
  action(:holiday_calendar_search) { |b| b.link(title: "Holiday Calendar Search (dev link)").click }
  action(:create_academic_calendar) { |b| b.link(title: "Create Academic Calendar").click }
  action(:copy_academic_calendar) { |b| b.link(title: "Copy Academic Calendar").click }
  action(:atp) { |b| b.link(title: "ATP").click }
  action(:date_range) { |b| b.link(title: "Date Range").click }
  action(:milestone) { |b| b.link(title: "Milestone").click }
  action(:enumeration) { |b| b.link(title: "Enumeration").click }
  action(:enumerated_value) { |b| b.link(title: "Enumerated Value").click }
  action(:message) { |b| b.link(title: "Message").click }
  action(:atp_type) { |b| b.link(title: "ATP Type").click }
  action(:atp_duration_type) { |b| b.link(title: "ATP Duration Type").click }
  action(:atp_seasonal_type) { |b| b.link(title: "ATP Seasonal Type").click }
  action(:date_range_type) { |b| b.link(title: "Date Range Type").click }
  action(:milestone_type) { |b| b.link(title: "Milestone Type").click }
  action(:user_preferences) { |b| b.link(title: "User Preferences").click }
  action(:quicklinks) { |b| b.link(title: "Quicklinks").click }
  action(:routing_report) { |b| b.link(title: "Routing Report").click }
  action(:routing_rules) { |b| b.link(title: "Routing Rules").click }
  action(:routing_rules_delegation) { |b| b.link(title: "Routing Rules Delegation").click }
  action(:routing_and_id_mgmt_doc_heirarchy) { |b| b.link(title: "Routing and Identity Management Document Type Hierarchy").click }
  action(:edoc_lite) { |b| b.link(title: "eDoc Lite").click }
  action(:people_flow) { |b| b.link(title: "People Flow").click }
  action(:notification_search) { |b| b.link(title: "Notification Search").click }
  action(:channel_subscriptions) { |b| b.link(title: "Channel Subscriptions").click }
  action(:delivery_types) { |b| b.link(title: "Delivery Types").click }
  action(:create_new_agenda) { |b| b.link(title: "Create New Agenda").click }
  action(:agenda_lookup) { |b| b.link(title: "Agenda Lookup").click }
  action(:attribute_definition_lookup) { |b| b.link(title: "Attribute Definition Lookup").click }
  action(:term_lookup) { |b| b.link(title: "Term Lookup").click }
  action(:term_specification_lookup) { |b| b.link(title: "Term Specification Lookup").click }
  action(:category_lookup) { |b| b.link(title: "Category Lookup").click }
  action(:manage_population) { |b| b.link(title: "Manage Population (Lookup)").click }
  action(:population_maintenance_edoc) { |b| b.link(title: "Population Maintenance eDoc (New)").click }
  action(:schedule_of_classes) { |b| b.link(title: "Schedule of Classes").click }

end