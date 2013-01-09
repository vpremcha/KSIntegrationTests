class EditPopulation < PopulationsBase

  expected_element :active

  frame_element
  population_attribute_elements
  validation_elements
  include PopulationEdit

  element(:active) { |b| b.frm.radio(value: "kuali.population.population.state.active") }
  element(:inactive) { |b| b.frm.radio(value: "kuali.population.population.state.inactive") }
  element(:operation_element) { |b| b.frm.div(data_label: "Operation").span(index: 1) }

  value(:operation) { |b| b.operation_element.text }

  action(:update) { |b| b.frm.button(id: "button_updatePopulation").click; b.loading.wait_while_present }

end