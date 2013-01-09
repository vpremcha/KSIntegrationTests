@nightly
Feature: Schedule of Classes

  As an Admin I want to display a published schedule of classes for a specific term in order to
  understand the courses being offered, including both descriptive and scheduling info

  Background:
    Given I am logged in as admin
    And I am using the schedule of classes page

  Scenario: Successfully display schedule of classes by subject code and display individual course details
    When I search for course offerings by course by entering a subject code
    Then a list of course offerings with that subject code is displayed
    And the course offering details for a particular offering can be shown

  Scenario: Successfully display schedule of classes for a particular course and display course details
    When I search for course offerings by course by entering a course offering code
    Then a list of course offerings with that course offering code is displayed
    And the course offering details for a particular offering can be shown

  Scenario: Successfully display schedule of classes for a particular instructor and display course details
    When I search for course offerings by instructor
    Then a list of course offerings with activity offerings with that instructor is displayed

  Scenario: Successfully display schedule of classes for a particular department and display course details
    When I search for course offerings by department
    Then a list of course offerings for that department is displayed
    And the course offering details for a particular offering can be shown

  Scenario: Successfully display schedule of classes for a particular keyword for a course title or description search
    When I search for course offerings by title and department by entering a keyword
    Then a list of course offerings with that keyword is displayed
    And the course offering details for a particular offering can be shown

@draft
  Scenario: Ensure that only courses in published (or closed - later) state are displayed
    When I search for course offerings that are in draft status
    Then the course is not displayed in the list of course offerings

# Scenario: Verify that an appropriate message is displayed if no data is returned by the search
#  Scenario: Verify that an appropriate message is displayed if no criteria is entered for search by Course
#  Scenario: Verify that an appropriate message is displayed if no criteria is entered for search by Department
#  Scenario: Verify that an appropriate message is displayed if no criteria is entered for search by Instructor
#  Scenario: Verify that an appropriate message is displayed if no criteria is entered for search by Title & Description