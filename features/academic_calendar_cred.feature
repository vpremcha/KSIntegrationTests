@nightly
Feature: Academic Calendar CRED

  Background:
    Given I am logged in as admin
    And I create an Academic Calendar

  Scenario: Create and save academic calendar from blank
    Then the Make Official button should become active

  Scenario: Search for newly created academic calendar
    And I search for the calendar
    Then the calendar should appear in search results

  Scenario: Make Academic Calendar Official
    When I make the calendar official
    And I search for the calendar
    Then the calendar should be set to Official
  @bug @KSENROLL-3442
  Scenario: Copy an Academic Calendar
    And I copy the Academic Calendar
    Then the Make Official button should become active
  @bug @KSENROLL-3442
  Scenario: Update Academic Calendar
    When I update the Academic Calendar
    And I search for the calendar
    Then the calendar should reflect the updates
  @bug @KSENROLL-3443
  Scenario: Delete Academic Calendar
    When I delete the Academic Calendar draft
    And I search for the calendar
    Then the calendar should not appear in search results

  Scenario: Search for Academic Calendar using wildcards
    When I search for the Academic Calendar using wildcards
    Then the calendar should appear in search results

  Scenario: Search for Academic Calendar using partial name
    When I search for the Academic Calendar using partial name
    Then the calendar should appear in search results