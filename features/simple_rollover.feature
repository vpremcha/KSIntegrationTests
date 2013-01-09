@nightly
Feature: Simple Rollover


  As a central administrator, I want to manually trigger the rollover process so that eligible course
  offering data from the source term will be copied over to create new course offerings in the target term.

  Background:
    Given I am logged in as admin

  Scenario: Successfully rollover courses to target term
    When I initiate a rollover by specifying source and target terms
    Then the results of the rollover are available
    And course offerings are copied to the target term
    And the rollover can be released to departments

