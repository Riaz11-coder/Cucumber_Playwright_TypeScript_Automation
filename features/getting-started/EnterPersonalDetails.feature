@sep10 @smoke
Feature: Enter my Personal details

    As a customer, I should be able to enter my Personal details.

    #* AC1: Default field types and values should be as follows:
    #*          a. First Name: Text field is present.
    #*          b. Last Name: Text field is present.
    #*          c. Email Address: Text field is present and validates for email format.
    #*          d. Phone: The field allows numbers only.

    #* AC2: "How did you hear about us?" A standard dropdown list is present.
    #* AC3: The 'Next' button should be disabled if any required data is missing or invalid.

    Background:
        Given user is on the enrollment page

    Scenario: Verify First Name text field is present and required
        Then the "First Name" text field should be present and required

    Scenario: Verify Last Name text field is present and required
        Then the "Last Name" text field should be present and required

    Scenario: Verify Email Address field is present and required
        Then the "Email Address" text field should be present and required

    Scenario: Verify Phone field field is present, required, and allows only numbers
        Then the "Phone" text field should be present and required
        And the "Phone" text field should reject non-numeric characters

    Scenario: Verify presence of source dropdown
        Then the "How did you hear about us?" dropdown should be present

    Scenario Outline: Next button is disabled when required data is missing or invalid
        When user leaves <field> <condition>
        Then the "Next" button should be disabled

        Examples:
            | field         | condition                   |
            | First Name    | blank                       |
            | Last Name     | blank                       |
            | Email Address | blank                       |
            | Email Address | with invalid format         |
            | Phone         | with non-numeric characters |

