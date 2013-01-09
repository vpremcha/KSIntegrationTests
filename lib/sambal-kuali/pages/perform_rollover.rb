class PerformRollover < BasePage

  wrapper_elements
  frame_element

  expected_element :target_term

  element(:target_term) { |b| b.frm.text_field(name: "targetTermCode") }
  element(:source_term) { |b| b.frm.text_field(name: "sourceTermCode") }

  element(:target_term_input_div) { |b| b.frm.div(data_label: "Target Term")}
  action(:target_term_go) { |b| b.target_term_input_div.button(text: "Go").click; b.loading.wait_while_present }

  value(:target_term_code) { |b| b.frm.div(data_label: "Term Code").span(index: 2).text }
  value(:target_term_start_date) { |b| b.frm.div(data_label: "Term Start Date").span(index: 2).text }
  value(:target_term_end_date) { |b| b.frm.div(data_label: "Term End Date").span(index: 2).text }

  element(:target_term_validation_msg_list)  { |b| b.target_term_input_div.div(class: "uif-validationMessages uif-groupValidationMessages").ul }
  value(:target_term_first_validation_msg) { |b| b.target_term_validation_msg_list.link.text }

  element(:source_term_input_div) { |b| b.frm.div(data_label: "Source Term")}
  element(:source_term_go_element) { |b| b.source_term_input_div.button(text: "Go") }
  action(:source_term_go) { |b| b.source_term_go_element.click; b.loading.wait_while_present }

  element(:source_term_validation_msg_list)  { |b| b.source_term_input_div.div(class: "uif-validationMessages uif-groupValidationMessages").ul }
  value(:source_term_first_validation_msg) { |b| b.source_term_validation_msg_list.link.text }

  value(:source_term_code) { |b| b.frm.div(data_label: "Term Code", index: 1).span(index: 2).text }
  value(:source_term_start_date) { |b| b.frm.div(data_label: "Term Start Date", index: 1).span(index: 2).text }
  value(:source_term_end_date) { |b| b.frm.div(data_label: "Term End Date", index: 1).span(index: 2).text }

  element(:rollover_button) { |b| b.frm.button(text: /Rollover/) }

  action(:rollover_course_offerings) { |b| b.rollover_button.click; b.loading.wait_while_present }

  value(:status) { |b| b.frm.div(data_label: "Status").span(index: 2).text } #status shows after rollover initiated


# looks for next available target term in the one specified is used - returns actual target term code used
  def select_terms(m_target_term,m_source_term)
    actual_target_term = m_target_term
    select_target_term(actual_target_term)
    source_term.set m_source_term
    retry_ctr = 0

    while source_term_go_element.disabled? and retry_ctr < 30
      actual_target_term = increment_term_code_year(target_term.value)
      select_target_term(actual_target_term)
      retry_ctr = retry_ctr + 1
    end

    source_term_go
    loading.wait_while_present
    actual_target_term
  end

  private

  def select_target_term(term)
    target_term.set term
    target_term_go
    loading.wait_while_present
  end

  def increment_term_code_year(term_code)
    "#{term_code[0..1]}#{(term_code[2..3].to_i + 1)}#{term_code[4]}"
  end
end