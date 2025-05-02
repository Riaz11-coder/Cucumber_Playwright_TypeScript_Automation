@sep32 @stripe
Feature: Declined Payments
    Background:
        Given I have a valid Stripe API test key
        And I have initialized the Stripe client

    Scenario: Declined card payment
        Given I have a test customer with email "declined.user@example.com"
        When I create a payment intent for 1000 USD
        And I attach a declined test payment method "pm_card_chargeDeclined"
        And I confirm the payment intent
        Then the payment status should be "requires_payment_method"
        And I should receive a payment failed webhook