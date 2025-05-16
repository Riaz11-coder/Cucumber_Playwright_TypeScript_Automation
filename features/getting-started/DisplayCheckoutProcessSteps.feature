@sep08 @smoke
Feature: Display the steps of the checkout process

    As a customer, I should be able to know where I am in the checkout process using the stepper.

    #* AC1: The system should display the steps of the checkout process as "1-Start Application", "2-Payment Plan", and "3-Review".
    #* AC2: The system should highlight "Start Application" in blue.
    #* AC3: The system should display "Payment Plan" and "Review" in grey.

    Background:
        Given user is on the enrollment page

    Scenario: Verify the checkout process steps are displayed correctly
        Then the system should display the steps of the checkout process as:
            | Step Number | Step Name         |
            | 1           | Start Application |
            | 2           | Payment plan      |
            | 3           | Review            |
        And the system should highlight "Start Application" in blue
        And the system should display "Payment Plan" and "Review" in grey