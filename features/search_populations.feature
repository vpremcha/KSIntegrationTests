@pending
Feature: Search for an existing population

In order to avoid creating a duplicate population (alternate: In order to modify an existing population)
I want to search for a population

  Background:
    Given I am logged in as admin

  Scenario: Search for existing population by Name
    When I search populations for keyword "New Freshmen"
    Then the search results should include a population named "New Freshmen"
    And I view the population with name "New Freshmen" from the search results
    And the view of the population "name" field is "New Freshmen"
    And the view of the population "rule" field is "New Freshmen"
    And the view of the population "description" field is "New students admitted directly from high school"
    And the view of the population "state" field is "Active"

  Scenario: Search for existing population by description
    When I search populations for keyword "60-89 credit hours"
    Then the search results should include a population where the description includes "60-89 credit hours"

  Scenario: Search for existing population by state
    When I search for Active populations
    Then the search results should only include "active" populations
    And  I search for Inactive populations
    And the search results should only include "inactive" populations

  Scenario: View read-only details of population
    When I search populations with Keyword "Athlete"
    And I view the population with name "Athlete" from the search results
    Then the view of the population "name" field is "Athlete"
    And the view of the population "description" field is "Students who are members of an NCAA certified sport"
    And the view of the population "rule" field is "Athlete"
    And the view of the population "state" field is "Active"
