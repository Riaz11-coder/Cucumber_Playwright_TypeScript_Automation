@sep27
Feature: Error messages for the invalid expiration number

    As a user, I want to be informed when my card's expiration date has failed. 


    #* AC1: 1. An immediate error message should be thrown if the expiration number is too short or wrong:
    #*                  Your card's expiration date is incomplete.
    #*                  Your card's expiration year is in the past.

    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user has completed step two with a valid option
        And user is on step three of the enrollment process
    @known-failure
    Scenario: User receives error message for incomplete expiration date
        When user enters an incomplete expiration date
        And user clicks outside the expiration date field
        Then user should see the expiration date error message "Your card’s expiration date is incomplete."
    @known-failure
    Scenario: User receives error message for an expired expiration date in the wrong year
        When user enters an expired expiration date of a previous year
        And user clicks outside the expiration date field
        Then user should see the expiration date error message "Your card’s expiration year is in the past."
    @known-failure
    Scenario: User receives error message for an expired expiration date within the current year
        When user enters an expired expiration date of a previous month in the current year
        And user clicks outside the expiration date field
        Then user should see the expiration date error message "Your card’s expiration date is in the past."