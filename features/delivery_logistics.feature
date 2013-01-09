@wip
Feature: Delivery logistics

  As a Central Administrator or Dept Administrator, I want to edit an Activity Offering so that I can change the AO's actual delivery logistics (KSENROLL-2595)

  Background:
    Given I am logged in as admin
    Given I am managing a course offering

  Scenario: Save and process requested delivery logistics
    When I add requested delivery logistics to an activity offering
    And I save and process the requested delivery logistics
    And actual delivery logistics are created with the activity offering
    And the activity offering is updated when saved


