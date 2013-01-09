@wip
Feature: delete activity offerings

  CO 10.1: As a Departmental Administrator, I want to delete one or more Activity Offerings associated
  with a Course Offering so that the specific Activity Offering(s) will no longer be offered for the term.
  CO 10.2: As a Departmental Administrator, I want to receive confirmation that I have elected to delete
  Activity Offerings so that I will not accidentally delete Activity Offerings that I intend to keep.

  Background:
    Given I am logged in as admin
    Given I am managing a course offering

  Scenario: Delete three AOs
    When I delete the selected three AOs
    Then The AOs are Successfully deleted

  Scenario: Delete an AO
    When I delete an AO with Draft state
    Then The AO is Successfully deleted
