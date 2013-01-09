@nightly
Feature: Create seat pools

As an Administrator, I want to create one or more seat pools and add to my Activity Offering 
so that I can reserve seats in this Activity Offering for one or more populations of students.

  Background:
    Given I am logged in as admin
    Given I am managing a course offering

  Scenario: Successfully create a seat pool for a population by completing all fields
    When I create a seat pool for an activity offering by completing all fields
    Then the seats remaining is updated
    And the percent allocated for each row is updated
    And the activity offering is updated when saved

  Scenario: Enter seat pool seats that exceeds max enrollment
    When I create a seat pool for an activity offering by completing all fields
    And seats is set higher than max enrollment
    Then a warning message is displayed about seats exceeding max enrollment
    And the activity offering is updated when saved

  Scenario: Seat pools priorities are properly re-sequenced after an activity offering is saved
    When I create seat pools for an activity offering and priorities are duplicated and not sequential
    And the activity offering is updated when saved
    And the seat pool priorities are correctly sequenced

  Scenario:  Attempt to add a seat pool using a population that is already used for that activity offering
    When I add a seat pool using a population that is already used for that activity offering
    Then an error message is displayed about the duplicate population
    And the activity offering is updated when saved
    And the seat pool is not saved with the activity offering

  @bug @KSENROLL-2869
  Scenario: Attempt to add a seat pool without all required fields
    When I add a seat pool without specifying a population
    Then an error message is displayed about the required seat pool fields
    And the activity offering is updated when saved
    And the seat pool is not saved with the activity offering

