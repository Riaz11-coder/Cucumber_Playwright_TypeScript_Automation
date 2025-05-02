@sep33 @stripe
Feature: Customer Management
    Background:
        Given I have a valid Stripe API test key
        And I have initialized the Stripe client

    Scenario: Create customer with payment method
        Given I create a new customer with:
            | email             | name          |
            | new.user@test.com | New Test User |
        When I attach a payment method "pm_card_mastercard" to the customer
        Then the customer should have 1 saved payment method
        And the payment method should be valid