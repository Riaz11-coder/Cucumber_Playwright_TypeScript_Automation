@db @integrity
Feature: Data Integrity Constraints
    As a database administrator
    I want to enforce data integrity rules
    So that the database remains consistent

    Scenario: Prevent duplicate company names
        Given a company named "Unique Corp" exists
        When I try to create another company named "Unique Corp"
        Then the operation should fail with a unique constraint error

    Scenario: Prevent duplicate driver license numbers
        Given a driver exists with license number "DL-12345"
        When I try to create another driver with license number "DL-12345"
        Then the operation should fail with a unique constraint error