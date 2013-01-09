@nightly
Feature: Search for a registration window

  Background:
    Given I am logged in as admin

  Scenario: Successfully search for Registration Windows
    When I manage Registration Windows for a term and a period
    Then I verify that all Registration Window fields are present

  Scenario: Validate input fields for One Slot per Window of Slot Allocation Method dropdown
    When I manage Registration Windows for a term and a period
    And I select One Slot per Window from Slot Allocation Method dropdown
    Then I verify that no One Slot per Window field is present

  Scenario: Validate input fields for Max Slotted Window of Slot Allocation Method dropdown
    When I manage Registration Windows for a term and a period
    And I select Max Slotted Window from Slot Allocation Method dropdown
    Then I verify that Max Slotted Window fields are visible

  Scenario: Validate input fields for Uniform Slotted Window of Slot Allocation Method dropdown
    When I manage Registration Windows for a term and a period
    And I select Uniform Slotted Window from Slot Allocation Method dropdown
    Then I verify that Uniform Slotted Window fields are visible

  Scenario: Successfully add a new Registration Window
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    Then I verify that the Registration Window is created
    And I verify the new Registration Window's buttons are created
    And I verify the new Registration Window's read-only and editable fields

  Scenario: Add a new Registration Window whose Start Date falls out of the period dates
    Given I manage Registration Windows for a term and a period
    And I add a Registration Window with Start Date falling out of the period dates
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window whose End Date falls out of the period dates
    Given I manage Registration Windows for a term and a period
    And I add a Registration Window with End Date falling out of the period dates
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window whose Start Date is after the End Date
    Given I manage Registration Windows for a term and a period
    And I add a Registration Window with Start Date after the End Date
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window with the same Start Date and End Date whose End Time is before the Start Time
    Given I manage Registration Windows for a term and a period
    And I add a Registration Window with the same Start Date and End Date whose End Time is before the Start Time
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window with the same Start Date and End Date whose End Time is in AM and its Start Time is in PM
    Given I manage Registration Windows for a term and a period
    And I add a Registration Window with the same Start Date and End Date whose End Time is in AM and its Start Time is in PM
    Then I verify that the registration window is not created

  Scenario: Add two Registration Windows with the same name in the same Period
    Given I manage Registration Windows for a term and a period
    And I add two Registration Windows with the same name for the same Period
    Then I verify the Registration Window is unique within the same period

  Scenario: Add two Registration Windows with the same name in two different Periods
    Given I manage Registration Windows for a term and a period
    And I add two Registration Windows with the same name in two different Periods
    Then I verify each Registration Window is created within each period

  Scenario: Edit a Registration Window setting its Start Date outside the period dates
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I edit a Registration Window setting its Start Date outside the period dates
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window set its End Date outside the period dates
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I edit a Registration Window setting its End Date outside the period dates
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window set its Start Date after its End Date
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I edit a Registration Window setting its Start Date after its End Date
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window with the same Start Date and End Date set its Start Time after its End Time
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I edit a Registration Window with the same Start Date and End Date setting its Start Time after its End Time
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window with the same Start Date and End Date set its End Time in AM and its Start Time in PM
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I edit a Registration Window with the same Start Date and End Date setting its End Time in AM and its Start Time in PM
    Then I verify that the Registration Window is not modified

  Scenario: Delete a Registration Window
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I delete the Registration Window
    Then I verify that the Registration Window is deleted

  Scenario: Cancel Deleting a Registration Window by canceling the popup dialog
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I try deleting of the Registration Window but I cancel the delete
    Then I verify that the Registration Window is not deleted

  Scenario: Assign Student Appointments in Registration Window
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I assign Student Appointments in Registration Window
    Then I verify that no field is editable in Registration Window and the Window Name is a link to a popup

  Scenario: Break Student Appointments in Registration Window
    Given I manage Registration Windows for a term and a period
    And Successfully add a Registration Window for the period
    And I assign Student Appointments in Registration Window
    And I break Student Appointments in Registration Window
    Then I verify that all editable fields in Registration Window are editable and Window Name is not a link