@sep16
Feature: Click on the next button on payment plans page   #! Test Only

    As a customer, I should be able to click on the next button on step 2 when I select a plan.

    #* AC1: Clicking on any plan should activate the next button
    #* AC2: When the customer clicks on the next button, the Step 3 page should be displayed.
    #* AC3: In the stepper, steps 1 and 2 should be green, and step 3 should be blue.
    #* AC4: The payment component should be displayed.
    #* AC5: A price summary should be displayed.
    #* AC6: The back button should be displayed.
    #* AC7: By default, the pay button should be displayed.

    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user is on step two of the enrollment process

    Scenario Outline: Verify next button is enabled after selecting a payment plan
        When user selects the "<payment_plan>" payment plan
        Then the next button should be enabled

        Examples:
            | payment_plan   |
            | Upfront        |
            | 5 Installments |
    
    Scenario Outline: Navigate to step three after selecting a payment plan
        When user selects the "<payment_plan>" payment plan
        And user clicks on the next button
        Then the Step 3 page should be displayed
        And the payment component should be displayed
        And a price summary should be displayed
        And the back button should be displayed
        And the pay button should be displayed by default

        Examples:
            | payment_plan   |
            | Upfront        |
            | 5 Installments |

    Scenario Outline: Verify stepper color changes after selecting a payment plan
        When user selects the "<payment_plan>" payment plan
        And user clicks on the next button
        Then the stepper should show steps 1 and 2 as green
        And step 3 should be blue

        Examples:
            | payment_plan   |
            | Upfront        |
            | 5 Installments |

