class ManagePopulations < PopulationsBase

  expected_element :keyword

  frame_element
  population_lookup_elements
  green_search_buttons
  include PopulationsSearch

  action(:create_new) { |b| b.frm.link(text: "Create New").click }
end