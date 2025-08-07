@sep23
Feature: Make a payment

    As a customer, I should be able to make payments so I can enroll in the program.

    #* AC1: When the user enters valid card information, checks the terms and conditions checkbox, 
    #*      and clicks on the Pay button, then they should be redirected to the confirmation page.

    #* AC2: In the stepper, steps 1, 2, 3 should be green.
    #* AC3: The correct program name should be displayed.
    #* AC4: The correct user email should be displayed.
    #* AC5: The correct company contact information should be displayed.

    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user has completed step two with a valid option
        And user is on step three of the enrollment process
    @known-failure
    Scenario: Successful payment with valid card information and confirmation details
        When user enters valid card information
        And user checks the terms and conditions checkbox
        And user clicks on the Pay button
        Then user is redirected to the confirmation page
        And steps 1, 2, and 3 in the stepper are green
        And the correct program name is displayed
        And the correct user email is displayed
        And the correct company contact information is displayed



