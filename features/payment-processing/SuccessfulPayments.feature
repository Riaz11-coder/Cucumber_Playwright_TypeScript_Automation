@sep30 @stripe
Feature: Successful Payments
    Background:
        Given I have a valid Stripe API test key
        And I have initialized the Stripe client

    Scenario: Successful card payment
        Given I have a test customer with email "test.user@example.com"
        When I create a payment intent for 2500 USD
        And I attach a valid test payment method "pm_card_visa"
        And I confirm the payment intent
        Then the payment status should be "succeeded"
        And I should receive a payment confirmation webhook