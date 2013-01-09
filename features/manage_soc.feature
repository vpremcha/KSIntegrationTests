@wip
Feature: Manage SOC

As Central Administrator, I want to process delivery logistics requests for all Activity Offerings within a selected Term
so that delivery logistics can be assigned (Mass Scheduling Event)

  Background:
    Given I am logged in as admin

  Scenario: Lock the SOC but canceled the process
    Given the SOC is valid for "Lock" for the term "20172"
    When I "Lock" the SOC and press "No" on the confirm dialog
    Then I verify that "Lock" button is enabled for next action


  Scenario: Lock the SOC and continue with the process
    Given the SOC is valid for "Lock" for the term "20172"
    When I "Lock" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Schedule" button is enabled for next action


  Scenario: Send AOs to the scheduler for a term but canceled the process
    Given the SOC is valid for "Schedule" for the term "20172"
    When I "Schedule" the SOC and press "No" on the confirm dialog
    Then I verify that "Schedule" button is enabled for next action


  Scenario: Send AOs to the scheduler for a term and continue with the process
    Given the SOC is valid for "Schedule" for the term "20172"
    When I "Schedule" the SOC and press "Yes" on the confirm dialog
    Then I verify that "FinalEdit" button is enabled for next action


  Scenario: Process the SOC for Final Edit but canceled the process
    Given the SOC is valid for "FinalEdit" for the term "20172"
    When I "FinalEdit" the SOC and press "No" on the confirm dialog
    Then I verify that "FinalEdit" button is enabled for next action


  Scenario: Process the SOC for Final Edit and continue with the process
    Given the SOC is valid for "FinalEdit" for the term "20172"
    When I "FinalEdit" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Publish" button is enabled for next action


  Scenario: Publish the SOC for a term but canceled the process
    Given the SOC is valid for "Publish" for the term "20172"
    When I "Publish" the SOC and press "No" on the confirm dialog
    Then I verify that "Publish" button is enabled for next action


  Scenario: Publish the SOC for a term and continue with the process
    Given the SOC is valid for "Publish" for the term "20172"
    When I "Publish" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Close" button is enabled for next action


