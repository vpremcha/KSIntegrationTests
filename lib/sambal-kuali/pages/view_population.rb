class ViewPopulation < PopulationsBase

  frame_element
  population_view_elements

  expected_element :name_label

  def child_populations
    pops = []
    child_populations_table.rows.each do |row|
      pops << row.text
    end
    pops.delete_if { |item| item == "Name" }
    pops.delete_if { |item| item == "" }
    pops
  end

end