import { Given, When, Then } from "@cucumber/cucumber";
import assert from "assert";
import { CustomWorld } from '../../hooks/globalHooks';

Given('a company named {string} exists', 
  async function (this: CustomWorld, companyName: string) {
    await this.dbUtils.dbFactories.createCompany({
      company_name: companyName,
      email: `${companyName.toLowerCase().replace(/\s+/g, '')}@example.com`
    });
  }
);

When('I try to create another company named {string}', 
  async function (this: CustomWorld, companyName: string) {
    try {
      await this.dbUtils.dbFactories.createCompany({
        company_name: companyName,
        email: `duplicate@${companyName.toLowerCase().replace(/\s+/g, '')}.com`
      });
      this.testData.error = null;
    } catch (error) {
      this.testData.error = error;
    }
  }
);

Given('a driver exists with license number {string}', 
  async function (this: CustomWorld, licenseNumber: string) {
    const company = await this.dbUtils.dbFactories.createCompany({
      company_name: "Driver Company",
      email: "drivers@example.com"
    });
    
    await this.dbUtils.dbFactories.createDriver({
      company_id: company.company_id,
      first_name: "First",
      last_name: "Driver",
      license_number: licenseNumber
    });
  }
);

When('I try to create another driver with license number {string}', 
  async function (this: CustomWorld, licenseNumber: string) {
    // Find any existing company
    const company = await this.db.companies.findFirst();
    if (!company) {
      // Create a company if none exists
      this.testData.company = await this.dbUtils.dbFactories.createCompany({
        company_name: "Test Company",
        email: "test@example.com"
      });
    }
    
    try {
      await this.dbUtils.dbFactories.createDriver({
        company_id: company ? company.company_id : this.testData.company.company_id,
        first_name: "Second",
        last_name: "Driver",
        license_number: licenseNumber
      });
      this.testData.error = null;
    } catch (error) {
      this.testData.error = error;
    }
  }
);

Then('the operation should fail with a unique constraint error', 
  function (this: CustomWorld) {
    // Check if error exists
    assert.ok(this.testData.error, "Expected an error but none occurred");
    
    // Check for unique constraint error code (Prisma P2002)
    if (this.testData.error.code) {
      assert.strictEqual(
        this.testData.error.code,
        "P2002",
        `Expected P2002 unique constraint error but got ${this.testData.error.code}`
      );
    }
    // Check for unique constraint message patterns
    else {
      const errorMessage = this.testData.error.message.toLowerCase();
      const expectedPatterns = [
        "unique constraint",
        "duplicate key",
        "already exists",
        "unique constraint failed"
      ];
      
      const found = expectedPatterns.some(pattern => 
        errorMessage.includes(pattern)
      );
      
      assert.ok(
        found,
        `Error message doesn't indicate unique constraint: ${this.testData.error.message}`
      );
    }
  }
);