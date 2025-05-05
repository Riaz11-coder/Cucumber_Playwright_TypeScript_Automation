@sep25
Feature: Error message for the invalid card number

    As a user, I want to be informed when my card info has failed. 

    #* AC1: An immediate error message should be thrown if the card number is wrong or too short:
    #*              Your card number is incomplete.
    #*              Your card number is invalid.

    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user has completed step two with a valid option
        And user is on step three of the enrollment process

    Scenario: User receives error message for incomplete card number
        When user enters an incomplete card number
        And user clicks outside the card number field
        Then user should see the credit card field error message "Your card number is invalid."

    Scenario: User receives error message for invalid card number
        When user enters an invalid card number
        And user clicks outside the card number field
        Then user should see the credit card field error message "Your card number is invalid."