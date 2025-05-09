@sep14
Feature: Selecting a price plan

    As a customer, I want to be able to Choose a payment plan from the available options 
    so that I can choose the one that best suits my needs.

    #* AC1: When the user selects any payment plan (Accordion) that option should be highlighted to indicate selection.
    #* AC2: Upon selecting any pricing option, the 'Next' button should become active (indicating the user can proceed).
    #* AC3: Users should be able to change their plan selections at any time before finalizing their choice.
   
    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user is on step two of the enrollment process

    Scenario Outline: Verify payment plan is highlighted
        When user selects the "<payment_plan>" payment plan
        Then the selected plan should be highlighted
        And the 'Next' button should be active

        Examples:
            | payment_plan   |
            | Upfront        |
            | 5 Installments |
    @known-failure
    Scenario Outline: Verify user can change the selected payment plan
        When user selects the "<payment_plan>" payment plan
        And user changes payment plan selection
        Then the newly selected payment plan should be highlighted
        And the previous selection should no longer be highlighted

        Examples:
            | payment_plan   |
            | Upfront        |
            | 5 Installments |