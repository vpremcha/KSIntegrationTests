@nightly
Feature: Create Populations

In order to reserve seats in a course offering for a group of students 
I want to create populations by using rules, and based on other populations

  Background:
    Given I am logged in as admin

  Scenario: Successfully create a new population using a rule
    When I create a population that is rule-based
    Then the population exists with a state of "active"

  Scenario: Successfully create a population using Union operation
    When I create a population that is union-based
    Then the population exists with a state of "active"

  Scenario: Successfully create a population using Exclusion operation
    When I create a population that is exclusion-based
    Then the population exists with a state of "active"

  Scenario: Successfully create a population using Intersection operation
    When I create a population that is intersection-based
    Then the population exists with a state of "active"

  Scenario: Attempt to create a population using a name that has already been associated with a population
    Given I have created a population that is rule-based
    When I create another population with the same name
    Then an error message appears stating "Please enter a different, unique population name"
    And there is no new population created

  Scenario: Attempt to create a union based pop with only 1 population
    When I try to create a population that is union-based with one population
    Then an error message appears stating "must select at least 2 different populations"

  Scenario: Attempt to create exclusion based population with no reference population
    When I try to create a population that is exclusion-based with no reference population
    Then an error message appears stating "Reference Population: Required"

  Scenario: Successfully create exclusion based population with 2 child populations
    When I create an exclusion-based population with 2 child populations
    Then the population exists with a state of "active"

  Scenario: Successfully create union based based population with 3 populations
    When I create an union-based population with 3 populations
    Then the population exists with a state of "active"

  Scenario: Attempt to build a union based population using the duplicate component populations
    When I create a union-based population with duplicate component populations
    Then an error message appears stating "must select at least 2 different populations"

  Scenario: Attempt to build an intersection based population using the duplicate parent populations
    When I create an intersection-based population with duplicate component populations
    Then an error message appears stating "must select at least 2 different populations"

  Scenario: Attempt to build an exclusion based population using the same population for the reference and excluded population
    When I create an exclusion-based population using the population for the reference and excluded population
    Then an error message appears stating "must not be in the source population"