class CreatePopulation < PopulationsBase

  expected_element :name

  frame_element
  population_attribute_elements
  validation_elements
  include PopulationEdit

  element(:union_radio) { |b| b.frm.radio(value: "kuali.population.rule.type.union") }

  action(:by_using_populations) { |b| b.frm.link(id: "link_byUsingPopulations").click; b.loading.wait_while_present }
  action(:by_rule) { |b| b.frm.link(id: "link_byRule").click; b.loading.wait_while_present }
  action(:union) { |b| b.union_radio.set }
  action(:intersection) { |b| b.frm.radio(value: "kuali.population.rule.type.intersection").set }
  action(:exclusion) { |b| b.frm.radio(value: "kuali.population.rule.type.exclusion").set }
  action(:create) { |b| b.frm.button(id: "button_createPopulation").click; b.loading.wait_while_present }

end