@nightly
Feature: Edit seat pools

As an Administrator, I want to modify attributes of one of the seat pools for the 
Activity Offering so that the seat pool reflects current business needs.

  Background:
    Given I am logged in as admin
    Given I am managing a course offering

  Scenario: Edit existing seat pool seat count and expiration milestone
    When I edit an existing activity offering with 1 seat pool
    And I change the seat pool count and expiration milestone
    Then the seats remaining is updated
    And the activity offering is updated when saved

  Scenario: Edit existing seat pool priorities
    When I edit an existing activity offering with 2 seat pools
    And I switch the priorities for 2 seat pools
    And the activity offering is updated when saved
    Then the updated seat pool priorities are saved

  Scenario: Edit total max enrollment
    When I edit an existing activity offering with 2 seat pools
    And I increase the overall max enrollment
    Then the seats remaining is updated
    And the activity offering is updated when saved
