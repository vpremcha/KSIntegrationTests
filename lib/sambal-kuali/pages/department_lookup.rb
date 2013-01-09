class DepartmentLookup < BasePage

  wrapper_elements
  green_search_buttons
  expected_element :short_name

  def frm
    self.frame(class: "fancybox-iframe")
  end

  element(:short_name) { |b| b.frm.div(data_label: "Short Name").text_field }
  element(:long_name) { |b| b.frm.div(data_label: "Long Name").text_field }
  element(:results_table) { |b| b.frm.div(id: "uLookupResults").table(index: 0) }

  element(:paginate_links_span) { |b| b.frm.div(class: "dataTables_paginate paging_full_numbers").span() }

  # Clicks the 'return value' link for the named row
  def return_value(short_name)
    target_row(short_name).wait_until_present
    target_row(short_name).link(text: "return value").wait_until_present
    begin
      target_row(short_name).link(text: "return value").click
    rescue Timeout::Error => e
      puts "rescued target_row dept lookup"
    end
    loading.wait_while_present
  end

  def target_row(short_name)
    results_table.row(text: /#{short_name}/)
  end

  def change_results_page(page_number)
    results_table.wait_until_present
   paginate_links_span.link(text: "#{page_number}").click
  end
end