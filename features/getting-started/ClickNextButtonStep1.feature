@sep19 @smoke
Feature: Click on the next button on step 1

    As a customer, I should be able to click on the next button on step 1 when I give valid information.

    #* AC1: The next button should take customers to step 2 when given valid information.
    #*              a. Test by providing all fields
    #*              b. Test by providing only the required fields
    

    Background:
        Given user is on the enrollment page

    Scenario: Proceed to step 2 with all fields filled
        When user enters a valid first name
        And user enters a valid last name
        And user enters a valid email address
        And user enters a valid phone number
        And user selects an option for "How did you hear about us?"
        And user clicks on the "Next" button
        Then user should be taken to step 2

    Scenario: Proceed to step 2 with only required fields filled
        When user enters a valid first name
        And user enters a valid last name
        And user enters a valid email address
        And user enters a valid phone number
        And user clicks on the "Next" button
        Then user should be taken to step 2