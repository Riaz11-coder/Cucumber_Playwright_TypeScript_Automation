import { Given, When, Then } from "@cucumber/cucumber";
import assert from "assert";
import { CustomWorld } from '../../hooks/globalHooks';

Given('I have a new company named {string}', 
  async function (this: CustomWorld, companyName: string) {
    this.testData.companyData = {
      company_name: companyName,
      email: `${companyName.toLowerCase().replace(/\s+/g, '')}@example.com`
    };
  }
);

When('I create the company in the database', 
  async function (this: CustomWorld) {
    this.testData.company = await this.dbUtils.dbFactories.createCompany(
      this.testData.companyData
    );
  }
);

Then('the company should exist with name {string}', 
  async function (this: CustomWorld, expectedName: string) {
    const company = await this.db.companies.findUnique({
      where: { company_id: this.testData.company.company_id }
    });
    
    assert.ok(company, "Company not found");
    assert.strictEqual(company?.company_name, expectedName);
  }
);

Given('an existing company named {string}', 
  async function (this: CustomWorld, companyName: string) {
    this.testData.company = await this.dbUtils.dbFactories.createCompany({
      company_name: companyName,
      email: `${companyName.toLowerCase().replace(/\s+/g, '')}@example.com`
    });
  }
);

When('I update the company email to {string}', 
  async function (this: CustomWorld, newEmail: string) {
    await this.db.companies.update({
      where: { company_id: this.testData.company.company_id },
      data: { email: newEmail }
    });
  }
);

Then('the company should have email {string}', 
  async function (this: CustomWorld, expectedEmail: string) {
    const company = await this.db.companies.findUnique({
      where: { company_id: this.testData.company.company_id }
    });
    
    assert.strictEqual(company?.email, expectedEmail);
  }
);

When('I delete the company', 
  async function (this: CustomWorld) {
    await this.db.companies.delete({
      where: { company_id: this.testData.company.company_id }
    });
  }
);

Then('the company should not exist in the database', 
  async function (this: CustomWorld) {
    const company = await this.db.companies.findUnique({
      where: { company_id: this.testData.company.company_id }
    });
    
    assert.strictEqual(company, null);
  }
);