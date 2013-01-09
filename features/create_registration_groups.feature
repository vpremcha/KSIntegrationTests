@wip
Feature: Create registration groups

As an Administrator, I want to create registration groups for a Course Offering

  Background:
    Given I am logged in as admin

  Scenario: RG 2.1A: Successfully create a activity offering cluster (for a course offering with a single activity offering type) and assign activity offerings to the cluster DONE
    Given I manage registration groups for a course offering
    When I create an activity offering cluster
    And I assign an activity offering to the cluster
    Then the activity offering is shown as part of the cluster
    And the remaining activity offerings are shown as unassigned

  Scenario: RG 2.1B/2.4B: Successfully create a default activity offering cluster and reg groups?????? with all activity offerings assigned to the cluster DONE
    Given I manage registration groups for a course offering
    When I generate registration groups with no activity offering cluster
    Then a default activity offering cluster is created
    And all activity offerings are assigned to the cluster
    And the registration groups are generated for the default cluster
    And there are no remaining unassigned activity offerings

  Scenario: RG 2.1C: Error message is displayed if I attempt to create 2 activity offering clusters with the same private name DONE
    Given I manage registration groups for a course offering
    When I create an activity offering cluster
    And I try to create a second activity offering cluster with the same private name
    #KSENROLL-4230  Registration groups - error message is not displayed when creating a cluster with a duplicate private name
    Then a create cluster dialog error message appears stating "duplicate cluster name"
    And only one activity offering cluster is created

  Scenario: RG 2.2A: Attempt to generate registration groups where the Activity Offering Cluster does not contain at least one Activity Offering for each Activity Offering Type which is part of the Format Offering definition. DONE
  #CHEM242
    Given I manage registration groups for a course offering with multiple activity types
    When I create an activity offering cluster
    And I assign two activity offerings of the same type to the cluster
    And I generate registration groups
    Then a cluster error message appears stating "This cluster must contain at least one activity from each of those associated with this Format"
    And registration groups are not generated

  Scenario: RG 2.2B - Cannot generate default (unconstrained) AOC unless there is at least one AO for each AO Type specified by the FO DONE
  #CHEM347
    Given I manage registration groups for a course offering with multiple activity types but no activity offering for one of the activity types
    When I generate registration groups with no activity offering cluster
    Then a registration groups error message appears stating "unassigned activity offering list must contain at least one activity from each of those associated with this Format"
    And no activity offering cluster is created
    #And no registration groups are generated

  Scenario: RG 2.3A: Generate registration groups where the max enrolment is not equal for activity types within the constrained activity offering cluster DONE
    Given I manage registration groups for a course offering with 2 activity types
    When I create an activity offering cluster
    And I assign two activity offerings of different types and different max enrolment
    And I generate registration groups
    Then a cluster warning message appears stating "The sums of maximum enrollment seats for each activity offering type are not equal"
    And a registration group is generated

  Scenario: RG 2.3B - Generate registration groups where the max enrolment is not equal for activity types within the DEFAULT activity offering cluster DONE
    Given I manage registration groups for a course offering with multiple activity types where the total max enrolment for each type is not equal
    When I generate registration groups with no activity offering cluster
    Then a cluster warning message appears stating "The sums of maximum enrollment seats for each activity offering type are not equal"
    And the registration groups are generated for the default cluster

  Scenario: RG 2.4A: Successfully generate registration groups for several constrained activity offering clusters with assigned activity offerings      DONE
  #CHEM317?
    Given I manage registration groups for a course offering with 2 activity types
    When I create 2 activity offering clusters
    And I assign two activity offerings to each cluster
    And I generate all registration groups
    Then registration groups are generated

#2.4B see above

  Scenario: RG 2.4C: Generate registration groups for several constrained activity offering clusters with assigned activity offerings with scheduling conflicts     DONE
  #CHEM455?
    Given I manage registration groups for a course offering with multiple activity types where there are activity offering scheduling conflicts
    When I create 2 activity offering clusters
    And I assign two activity offerings to each cluster with scheduling conflicts
    And I generate registration groups
    Then a cluster warning message appears stating "invalid due to scheduling conflicts"
    And registration groups are generated
    And registration groups with time conflicts are marked as invalid

  Scenario: RG 2.4D: Generate Reg Groups for default AO Cluster where there are scheduling time conflicts.    DONE
  #CHEM455?
    Given I manage registration groups for a course offering with multiple activity types where there are activity offering scheduling conflicts
    When I generate registration groups with no activity offering cluster
    Then a default activity offering cluster is created
    And all activity offerings are assigned to the cluster
    And the registration groups are generated for the default cluster
    And there are no remaining unassigned activity offerings
    And a cluster warning message appears stating "invalid due to scheduling conflicts"
    And registration groups with time conflicts are marked as invalid

  #Scenario: RG 2.4c/d alternative - reg groups already generated (default/constrained), assign an activity offering that to groups that causes scheduling conflicts

  Scenario: RG 3.1A: assign one or more AOs to an existing constrained AOC and update the Reg Groups for this FO       DONE
    Given I have generated a registration group for a course offering with lecture and quiz activity types leaving some activity offerings unassigned
    When I assign a quiz activity offering to the existing activity offering cluster
    Then a cluster status message appears stating "Only Some Registration Groups Generated"
    And I generate registration groups
    Then additional registration groups are generated for the new quiz
    And the quiz is not listed as an unassigned activity offering

  Scenario: RG 3.1B: assign one or more AOs to an existing default AOC and update the Reg Groups for this FO - DONE but fails
  #existing reg group ids don't change
    Given I have created the default registration group for a course offering
    And I add two activity offerings to the course offering
    When I manage registration groups for the existing course offering
    And I confirm that the activity offerings are listed as unassigned
    Then a cluster status message appears stating "Only Some Registration Groups Generated"         #fails on this step
    And I assign the new activity offerings to the default activity offering cluster
    And I generate registration groups
    Then additional registration groups are generated for the new activity offerings
    And the new activity offerings are not listed as an unassigned activity offerings

#what is the difference between RG 3.1A and 3.1C -- 3.1C is specifically the delta test
  Scenario: RG 3.1C: assign an AO to an AOC with RGs and generate only the new RG for that new AO leaving the existing RGs unchanged  DONE*
    Given I have generated a registration group for a course offering with lecture and quiz activity types leaving some activity offerings unassigned
    #And I manage registration groups for the course offering
    When I assign a quiz activity offering to the existing activity offering cluster
    Then a cluster status message appears stating "Only Some Registration Groups Generated"
    And I generate registration groups
    Then the registration group is updated
    And the quiz is not listed as an unassigned activity offering

  Scenario: RG 3.2A: Move one or more AOs from their assigned AO Cluster to another AO Cluster and update the Reg Groups appropriately   DONE
    Given I have generated two registration groups for a course offering with lecture and quiz activity types
    #And I manage registration groups for the course offering
    When I move a quiz activity offering from the first activity offering cluster to the second activity offering cluster
    Then a cluster status message appears stating "Only Some Registration Groups Generated"
    And I generate all registration groups
    Then the registration groups sets are updated

  Scenario: RG 3.2B: Move one or more AOs from the default AO Cluster to a new constrained cluster and update the Reg Groups appropriately   DONE
    Given I have created the default cluster and related registration groups for a course offering with lecture and lab activity types
    #And I manage registration groups for the course offering
    When I create a new activity offering cluster
    And I move a lab activity offering from the default activity offering cluster to the new activity offering cluster
    And I move a lecture activity offering from the default activity offering cluster to the new activity offering cluster
    And a cluster status message appears stating "No Registration Groups Generated"
    And I generate all registration groups
    Then the registration groups sets are updated

   Scenario: RG 3.3A: Remove one or more AOs from a constrained AOC, leaving the AOs orphaned and without a Reg Group association  10
   #CHEM221?
    Given I have generated a registration group for a course offering with lecture and quiz activity types
    #And I manage registration groups for the course offering
    When I remove a lab activity offering to the existing activity offering cluster
    Then the registration group set is updated
    And the lab is now listed as an unassigned activity offering

  Scenario: RG 3.3B: Remove an AO from a default AOC, leaving the AO orphaned and without a Reg Group association 9
  #CHEM221
    Given I have created the default cluster and related registration groups for a course offering with lecture and lab activity types
    And I manage registration groups for the course offering
    When I remove a lab activity offering to the existing activity offering cluster
    Then the registration group set is updated
    And the lab is now listed as an unassigned activity offering

  Scenario: RG 3.4A: Successfully modify published and private names for an AO Cluster  8
    Given I have created an activity offering cluster for a course offering
    And I manage registration groups for the course offering
    When I change the activity offering cluster published and private names
    Then activity offering cluster published and private names are successfully changed

  Scenario: 3.4B: Error message is displayed if I attempt to rename an existing activity offering cluster with an existing private name  7
    Given I have created two activity offering clusters for a course offering
    When I manage registration groups for the course offering
    And I change the private name of the first activity offering cluster using the private name of the second
    Then an error message appears stating "duplicate cluster name"
    And the first activity offering cluster private name is not changed

  Scenario: RG 3.5A: Delete a constrained AO Cluster and all of its associations with AOs, and also deletes the related Reg Groups   6
  #CHEM317? (in draft status)
    Given I have created activity offering clusters and related registration groups for a course offering with lecture and lab activity types
    And I manage registration groups for the course offering
    When I delete the first activity offering cluster
    Then the associated registration groups are deleted
    And the associated activity offerings are now listed as unassigned

  Scenario: RG 3.5B: Delete an unconstrained/default AO Cluster and all of its associations with AOs, and also deletes the related Reg Groups     5
    Given Given I have created the default activity offering cluster and related registration groups for a course offering
    When I manage registration groups for the course offering
    And I delete the default activity offering cluster
    Then the registration groups are deleted
    And the associated activity offerings are now listed as unassigned



#suspend AO functionality in M6?
#  Scenario: Generate registration groups - suspended or cancelled activity offerings are excluded
#    Given I am logged in as admin
#    And I manage course offerings for a course offering with a single actvitiy #use ENGL103A (delete if exists, then copy ENGL103)
#    When I set an activity offering status to cancelled 
#    And I generate unconstrained registration groups
#    Then registration groups are not generated for the activity offering in cancelled status

#suspend CO functionality?
# Scenario: Generate registration groups - cannot be generated for course offering in '???' status (can be generated in Draft,Planned,Offered,Open)
#    Given I am logged in as admin
#    And I manage registration groups for a course offering with a single actvitiy #use ENGL103A (delete if exists, then copy ENGL103)
#    When I set an course offering to '???' #how change course offering status
#    And I generate unconstrained registration groups
#    Then registration groups are not generated for the course offering in '???' status

  Scenario: Copy activity offering and ensure registration groups are copied over   4
  #use ENGL103A (delete if exists, then copy ENGL103)
    Given I manage a course offering with a single activity type
    When I copy an activity offering with registration groups
    Then the registration groups are copied over with the activity offering
  
  Scenario: Copy course offering in the same term and ensure registration groups are copied over     3
  #use ENGL103A (delete if exists, then copy ENGL103)
    Given I manage course offerings for a subject area
    When I copy a course offering with registration groups
    Then the registration groups are copied over with the course offering  

  #Scenario: Copy course offering in the a prior term and ensure registration groups are copied over
  #  Given I am logged in as admin
  #  And I manage course offerings for a subject area
  #  When I copy a course offering with registration groups #use ENGL103A (delete if exists, then copy ENGL103)
  #  Then the registration groups are copied over with the course offering 

  Scenario: Perform rollover and ensure registration groups are copied over      2
    When I perform a rollover with a course offering with registration groups
    Then the registration groups are copied over with the course offering in the target term

  Scenario: Rollover course offering and ensure no registration groups are not automatically generated in the target term 1
    Given I am logged in as admin
    When I rollover a course offering with no registration groups
    Then the registration groups are not automatically generated with the course offering in the target term
  

  #how to delete format offering
  #Scenario: Delete format offering to ensure associated registration groups are deleted
  #  Given I am logged in as admin
  
