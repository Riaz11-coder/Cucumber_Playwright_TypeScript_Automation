@db @functional @crud
Feature: Company CRUD Operations
    As a system administrator
    I want to manage company records
    So that I can maintain accurate company information

    Scenario: Create and read a company
        Given I have a new company named "Acme Corp"
        When I create the company in the database
        Then the company should exist with name "Acme Corp"

    Scenario: Update a company
        Given an existing company named "Beta Inc"
        When I update the company email to "contact@beta.com"
        Then the company should have email "contact@beta.com"

    Scenario: Delete a company
        Given an existing company named "Gamma LLC"
        When I delete the company
        Then the company should not exist in the database