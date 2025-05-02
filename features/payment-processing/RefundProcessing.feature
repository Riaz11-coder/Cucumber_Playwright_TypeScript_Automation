@sep31 @stripe
Feature: Refund Processing
    Background:
        Given I have a valid Stripe API test key
        And I have initialized the Stripe client

    Scenario: Refund processed payment
        Given I have a successful payment of 5000 USD
        When I create a full refund for the payment
        Then the refund status should be "succeeded"
        And the payment balance should be 0
        And I should receive a refund created webhook