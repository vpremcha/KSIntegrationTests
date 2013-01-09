# Functional Automation testing for Kuali and Sakai

## Description:

This repository contains the following projects:

- Cucumber features and step definitions for testing Kuali Student
- The DSL for the Kuali Student project. This is called "Sambal-Kuali" and is its own Ruby gem (meaning it can be installed directly in Ruby with "gem install sambal-kuali", though this step is not absolutely necessary).

## DSL

The DSL is written in Ruby 1.9.2 using the Watir-webdriver and rSmart's "TestFactory" gem. It contains page and data object classes which allow the test code to persist information about parallel objects created within the system under test.

## Cucumber projects

You are of course welcome to use the DSL on your own to write your own test scripts using whatever framework you prefer. However, if you're interested in getting a fast start and either learning the DSL by example or leveraging work we've already done, you're welcome to grab our Cucumber projects.

## Contribute

* Fork the project.
* Additional or bug-fixed Classes, Elements, or Methods should be demonstrated in accompanying tests. Pull requests that do not include test scripts that use the new code are less likely to be accepted.
* Make sure you provide RDoc comments for any new public method or page class you add. Remember, others will be using this code.
* Send a pull request. Bonus points for topic branches.

	Copyright 2012 The Kuali Foundation

	Licensed under the Educational Community License, Version 2.0 (the "License");
	you may	not use this file except in compliance with the License.
	You may obtain a copy of the License at

    http://www.osedu.org/licenses/ECL-2.0

	Unless required by applicable law or agreed to in writing,
	software distributed under the License is distributed on an "AS IS"
	BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
	or implied. See the License for the specific language governing
	permissions and limitations under the License.

