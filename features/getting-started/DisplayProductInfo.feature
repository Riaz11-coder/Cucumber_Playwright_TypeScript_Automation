@sep09 @smoke
Feature: Display the product information

    As a customer, I should be able to see the product information.

    #* AC1: The product name should be displayed on the information card.
    #* AC2: The product name on the information card matches the product name on the left side of the screen.
    #* AC3: The price of the product should be displayed.
    #* AC4: The text indicating a flexible payment plan should be available and displayed.
    #* AC5: The program start date should be displayed.
    #* AC6: The return policy and the final date for returns should be displayed.

    Background:
        Given user is on the enrollment page

    Scenario: Verify product name is displayed and matches across sections
        Then the product name "Test Automation with Selenium" should be displayed on the information card
        And the product name on the information card should match "Test Automation with Selenium" on the left side

    Scenario: Verify product price is displayed
        Then the product price "$400" should be displayed

    Scenario: Verify flexible payment plan text
        Then the text "Flexible payments plan available" should be visible

    Scenario: Verify program start date is displayed
        Then the program start date "Apr 10, 2025" should be displayed

    Scenario: Verify refund policy and final return date
        Then the refund policy text "100% refund policy until" should be visible
        And the final refund date "May 10, 2025" should be displayed