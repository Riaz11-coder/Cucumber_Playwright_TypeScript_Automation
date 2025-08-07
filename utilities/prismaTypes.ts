import { PrismaClient } from '../generated/prisma';
import { Prisma } from '../generated/prisma';

const prisma = new PrismaClient();

// Helper to enforce required fields
type WithRequired<T, K extends keyof T> = T & Required<Pick<T, K>>;

// Define default values as separate objects
const companyDefaults: Partial<Prisma.companiesUncheckedCreateInput> = {
  address: '123 Main St',
  phone: '555-1234',
  contact_person: 'Test Contact',
  subscription_plan: 'Basic',
  is_active: true,
};

const driverDefaults: Partial<Prisma.driversUncheckedCreateInput> = {
  license_class: 'C',
  status: 'active',
  safety_score: 100.00,
  total_miles_driven: 0,
  years_experience: 0,
};

const vehicleDefaults: Partial<Prisma.vehiclesUncheckedCreateInput> = {
  fuel_type: 'Gasoline',
  transmission: 'automatic',
  status: 'active',
  odometer_reading: 0,
};

const departmentDefaults: Partial<Prisma.departmentsUncheckedCreateInput> = {
  manager_name: 'Department Manager',
  budget: 100000.00,
};

const expenseDefaults: Partial<Prisma.expensesUncheckedCreateInput> = {
  description: 'Test expense',
  vendor: 'Test Vendor',
  receipt_available: false,
};

// Company type with required fields
export type CompanyCreateParams = WithRequired<
  Prisma.companiesUncheckedCreateInput,
  'company_name' | 'email'
>;

// Driver type with required fields
export type DriverCreateParams = WithRequired<
  Prisma.driversUncheckedCreateInput,
  'company_id' | 'first_name' | 'last_name' | 'license_number'
>;

// Vehicle type with required fields
export type VehicleCreateParams = WithRequired<
  Prisma.vehiclesUncheckedCreateInput,
  'company_id' | 'vin' | 'license_plate' | 'make' | 'model' | 'year'
> & {
  fuel_type?: string;
  transmission?: string;
  status?: string;
  odometer_reading?: number;
};

// Department type with required fields
export type DepartmentCreateParams = WithRequired<
  Prisma.departmentsUncheckedCreateInput,
  'company_id' | 'department_name'
>;

// Expense type with required fields
export type ExpenseCreateParams = WithRequired<
  Prisma.expensesUncheckedCreateInput,
  'vehicle_id' | 'expense_date' | 'amount'
>;

// Factory functions with explicit type handling
export const dbFactories = {
  createCompany: async (data: CompanyCreateParams) => {
    return prisma.companies.create({
      data: {
        ...companyDefaults,
        ...data,
        subscription_plan: data.subscription_plan || 'Basic' // Ensure valid value
      }
    });
  },

  createDriver: async (data: DriverCreateParams) => {
    return prisma.drivers.create({
      data: {
        ...driverDefaults,
        ...data
      }
    });
  },

  createVehicle: async (data: VehicleCreateParams) => {
    return prisma.vehicles.create({
      data: {
        ...vehicleDefaults,
        ...data
      }
    });
  },

  createDepartment: async (data: DepartmentCreateParams) => {
    return prisma.departments.create({
      data: {
        ...departmentDefaults,
        ...data
      }
    });
  },

  createExpense: async (data: ExpenseCreateParams) => {
    return prisma.expenses.create({
      data: {
        ...expenseDefaults,
        ...data
      }
    });
  }
};

// Re-export Prisma and client
export { Prisma, prisma };
export default prisma;