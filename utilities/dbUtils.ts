import { prisma, dbFactories } from './prismaTypes';

/**
 * Resets the database by truncating all tables
 */
export async function resetDatabase() {
  const tablenames = await prisma.$queryRaw<
    Array<{ tablename: string }>
  >`SELECT tablename FROM pg_tables WHERE schemaname='public'`;

  for (const { tablename } of tablenames) {
    if (tablename !== '_prisma_migrations') {
      try {
        await prisma.$executeRawUnsafe(
          `TRUNCATE TABLE "public"."${tablename}" CASCADE;`
        );
      } catch (error) {
        console.error(`Error truncating table ${tablename}:`, error);
      }
    }
  }
}

/**
 * Creates test data for common scenarios
 */
export const testData = {
  createCompanyWithDrivers: async (driverCount: number = 3) => {
    const company = await dbFactories.createCompany({
      company_name: 'Test Company',
      email: 'test@company.com'
    });

    const drivers = [];
    for (let i = 0; i < driverCount; i++) {
      const driver = await dbFactories.createDriver({
        company_id: company.company_id,
        first_name: `Driver${i + 1}`,
        last_name: 'Test',
        license_number: `DL-${Math.random().toString(36).substring(2, 10)}`
      });
      drivers.push(driver);
    }

    return { company, drivers };
  },

  createCompanyWithVehicles: async (vehicleCount: number = 2) => {
    const company = await dbFactories.createCompany({
      company_name: 'Fleet Company',
      email: 'fleet@company.com'
    });

    const vehicles = [];
    for (let i = 0; i < vehicleCount; i++) {
      const vehicle = await dbFactories.createVehicle({
        company_id: company.company_id,
        vin: `VIN${Math.random().toString(36).substring(2, 12)}`,
        license_plate: `LP-${1000 + i}`,
        make: 'Ford',
        model: 'Transit',
        year: 2020 + i
      } as any); // Temporary fix until we update the type
      vehicles.push(vehicle);
    }

    return { company, vehicles };
  },

  createFullFleet: async () => {
    const company = await dbFactories.createCompany({
      company_name: 'Full Fleet Inc',
      email: 'fleet@example.com'
    });

    const department = await dbFactories.createDepartment({
      company_id: company.company_id,
      department_name: 'Logistics'
    });

    const driver = await dbFactories.createDriver({
      company_id: company.company_id,
      first_name: 'John',
      last_name: 'Doe',
      license_number: `DL-${Math.random().toString(36).substring(2, 10)}`
    });

    const vehicle = await dbFactories.createVehicle({
      company_id: company.company_id,
      department_id: department.department_id,
      assigned_driver_id: driver.driver_id,
      vin: `VIN${Math.random().toString(36).substring(2, 12)}`,
      license_plate: `LP-${Math.floor(Math.random() * 10000)}`,
      make: 'Mercedes',
      model: 'Sprinter',
      year: 2022
    } as any); // Temporary fix until we update the type

    return { company, department, driver, vehicle };
  }
};

/**
 * Helper to measure query performance
 */
export async function measureQuery<T>(
  query: () => Promise<T>
): Promise<{ result: T; duration: number }> {
  const start = Date.now();
  const result = await query();
  const duration = Date.now() - start;
  return { result, duration };
}

/**
 * Creates bulk test data
 */
export async function createBulkCompanies(count: number) {
  const companies = Array.from({ length: count }, (_, i) => ({
    company_name: `Company ${i + 1}`,
    email: `company${i + 1}@test.com`
  }));
  
  return prisma.companies.createMany({ data: companies });
}

/**
 * Database health check
 */
export async function checkDbConnection() {
  try {
    await prisma.$queryRaw`SELECT 1`;
    return true;
  } catch (error) {
    console.error('Database connection failed:', error);
    return false;
  }
}