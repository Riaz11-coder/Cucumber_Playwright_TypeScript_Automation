@sep17 @regression
Feature: View payment plan options in Step 2   #! test only

    As a customer, I should be able to see payment plan options in Step 2.

    #* AC1: Upfront payment:
    #*      There should be only one upfront price
    #*      Text should be:
    #*              Upfront  (first row)
    #*              $ <upfont_price> pay once (second row)

    #* AC2: Installment plans:
    #*      There must be total <num> Payment Plans
    #*      There can be <number_of_installments> installments
    #*      If there are installments:
    #*            Text should be
    #*            <number_of_installments> Installments (first row)
    #*           $ <monthly_price> per month (second row)
    #*            Installment plans should be unique

    Background:
        Given user is on the enrollment page
        And user has completed step one with valid information
        And user is on step two of the enrollment process

    Scenario: Verify Upfront payment plan
        Then there should be one upfront price
        And the upfront payment section text should display:
            | Upfront                   |
            | $<upfront_price> pay once |

    Scenario: Verify Installment payment plan
        Then there should be 5 installments
        And the installment payment section text should display:
            | 5 Installments             |
            | $<monthly_price> per month |

    Scenario: Verify payment plan structure
        Then the payment plan elements should appear in order:
            | Choose a payment plan |
            | Upfront               |
            | $400 pay once         |
            | 5 Installments        |
            | $100 per month        |

    
