class ActivityOfferingMaintenanceView < ActivityOfferingMaintenanceBase

    expected_element :header

    element(:header) { |b| b.frm.span(class: "uif-headerText-span") }

    value(:status) { |b| b.frm.div(data_label: "Status").span(index: 2).text }
    value(:term) { |b| b.frm.div(data_label: "Term").span(index: 2).text }
    value(:activity_type) { |b| b.frm.div(data_label: "Activity Type").span(index: 2).text }
    value(:format) { |b| b.frm.div(data_label: "Format").span(index: 2).text }

=begin
    As the maintenance view displays editable controls after submit instead of readonly, for now, changing it to looks for the controls
    value(:activity_code) { |b| b.frm.div(data_label: /Activity Code/).span(index: 2).text }
    value(:max_enrollment) { |b| b.frm.div(data_label: "Total Maximum Enrollment").span(index: 2).text }
=end
    value(:activity_code)  { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.aoInfo.activityCode").value }
    value(:max_enrollment)  { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.aoInfo.maximumEnrollment").value }

    def get_inst_effort(id)
      target_person_row(id).cells[INST_EFFORT_COLUMN].text
    end

=begin
    value(:course_url) { |b| b.frm.div(data_label: "Course URL").span(index: 2).text }
    value(:evaluation)  { |b| b.frm.div(data_label: "This lecture requires an evaluation").span().text }
    value(:honors){ |b| b.frm.div(data_label: "This is an honors course").span().text }
=end
    value(:course_url)  { |b| b.frm.text_field(id: "course_url_control").value }
    value(:evaluation)  { |b| b.frm.checkbox(id: "is_evaluated_control").set? }
    value(:honors){ |b| b.frm.checkbox(id: "is_honors_offering_control").set? }


    def get_priority(pop_name)
      target_pool_row(pop_name).cells[PRIORITY_COLUMN].text
      #target_pool_row(pop_name).div(id: /u886_line/).span(id: /u886_line/).text
    end

    def get_seats(pop_name)
      target_pool_row(pop_name).div(id: /seatLimit_line/).text
    end

    def get_expiration_milestone(pop_name)
      target_pool_row(pop_name).cells[EXP_MILESTONE_COLUMN].text
      #target_pool_row(pop_name).div(id: /u927_line/).span(id: /u927_line/).text
    end

    private

    def target_pool_row(pop_name)
      seat_pools_table.row(text: /#{Regexp.escape(pop_name.to_s)}/)
    end


end