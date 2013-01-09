When /^I search populations for keyword "(.*)"$/ do |arg|
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set arg
    page.search
  end
end

Then /^the search results should include a population named "(.*)"$/ do |pop_name|
  on ManagePopulations do |page|
    page.results_names.should include pop_name
  end
end

Then /^the search results should include a population where the description includes "(.*)"$/ do |descrin|
  on ManagePopulations do |page|
    page.results_descriptions.any? { |s| s.include?(descrin) }.should == true
    #page.results_descriptions.grep(/#{Regexp.escape(desc)}/).should
  end
end

When /^I search for Active populations$/ do
  go_to_manage_population
  on ManagePopulations do |page|
    page.active.set
    page.search
  end
end

When /^I search for Inactive populations$/ do
  go_to_manage_population
  on ManagePopulations do |page|
    page.inactive.set
    page.search
  end
end

Then /^the search results should only include "(.*)" populations$/ do |statein|
  on ManagePopulations do |page|
    page.results_states.each { |state| state.should == statein }
  end
end

When /^I search populations with the Keyword "(.*)" and a State of "(.*)"$/ do |keywerd, state|
  methd = state.downcase
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set keywerd
    page.send(methd)
    page.search
  end
end

Then /^the search results should include a population with Name "(.*)" and State "(.*)"$/ do |name, state|
  on ManagePopulations do |page|
    page.results_list.should include name
    page.status(name).should == state
  end
end

When /^I search populations with Keyword "(.*)"$/ do |keywerd|
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set keywerd
    page.search
  end
end

And /^I view the population with name "(.*)" from the search results$/ do |name|
  on ManagePopulations do  |page|
    page.view name
  end
end

And /^the view of the population "(.*)" field is "(.*)"$/ do |field, value|
  methd = field.downcase
  on ViewPopulationDiag do |page|
    page.send(methd[field]).should == value
  end
end

Given /^I set the population "(.*)" to state "(.*)"$/ do |pop, state|
  methd = state.downcase
  go_to_manage_population
  on ManagePopulations do |page|
    page.keyword.set pop
    page.search
    page.edit pop
  end
  on EditPopulation do |page|
    page.send(methd).set
    page.update
  end
end