-- Transmuda Fleet Management System Database
-- PostgreSQL version

-- ========================================
-- 1. COMPANY AND ORGANIZATIONAL STRUCTURE
-- ========================================

CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    contact_person VARCHAR(255),
    subscription_plan VARCHAR(20) DEFAULT 'Basic' CHECK (subscription_plan IN ('Basic', 'Professional', 'Enterprise')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    department_name VARCHAR(255) NOT NULL,
    manager_name VARCHAR(255),
    budget DECIMAL(12,2),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- ========================================
-- 2. USER MANAGEMENT AND ROLES
-- ========================================

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'fleet_manager', 'driver', 'mechanic', 'viewer')),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- ========================================
-- 3. DRIVERS AND PERSONNEL
-- ========================================

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    employee_id VARCHAR(50),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    license_class VARCHAR(10),
    license_expiry_date DATE,
    date_of_birth DATE,
    hire_date DATE,
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone VARCHAR(20),
    salary DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'terminated')),
    safety_score DECIMAL(5,2) DEFAULT 100.00,
    total_miles_driven DECIMAL(12,2) DEFAULT 0,
    years_experience INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE driver_certifications (
    certification_id SERIAL PRIMARY KEY,
    driver_id INTEGER,
    certification_name VARCHAR(255),
    issuing_authority VARCHAR(255),
    issue_date DATE,
    expiry_date DATE,
    certification_number VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

-- ========================================
-- 4. VEHICLES AND FLEET MANAGEMENT
-- ========================================

CREATE TABLE vehicle_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    fuel_efficiency_rating DECIMAL(5,2),
    capacity_passengers INTEGER,
    capacity_cargo_cubic_feet DECIMAL(8,2)
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    vehicle_type_id INTEGER,
    vin VARCHAR(17) UNIQUE NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(50),
    fuel_type VARCHAR(20) NOT NULL CHECK (fuel_type IN ('gasoline', 'diesel', 'electric', 'hybrid', 'natural_gas')),
    engine_size VARCHAR(20),
    transmission VARCHAR(20) DEFAULT 'automatic' CHECK (transmission IN ('manual', 'automatic', 'cvt')),
    purchase_date DATE,
    purchase_price DECIMAL(12,2),
    current_value DECIMAL(12,2),
    odometer_reading DECIMAL(12,2) DEFAULT 0,
    fuel_capacity DECIMAL(8,2),
    insurance_policy_number VARCHAR(100),
    insurance_expiry DATE,
    registration_expiry DATE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'maintenance', 'retired', 'accident', 'sold')),
    gps_device_id VARCHAR(100),
    assigned_driver_id INTEGER,
    department_id INTEGER,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(type_id),
    FOREIGN KEY (assigned_driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE vehicle_assignments (
    assignment_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    driver_id INTEGER,
    assigned_date DATE NOT NULL,
    end_date DATE,
    assignment_type VARCHAR(20) DEFAULT 'permanent' CHECK (assignment_type IN ('permanent', 'temporary', 'shared')),
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

-- ========================================
-- 5. MAINTENANCE AND REPAIRS
-- ========================================

CREATE TABLE maintenance_types (
    maintenance_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    recommended_interval_miles INTEGER,
    recommended_interval_months INTEGER,
    estimated_cost DECIMAL(8,2)
);

CREATE TABLE service_providers (
    provider_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    provider_name VARCHAR(255) NOT NULL,
    service_type VARCHAR(20) NOT NULL CHECK (service_type IN ('maintenance', 'repair', 'inspection', 'towing', 'parts')),
    contact_person VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    hourly_rate DECIMAL(8,2),
    rating DECIMAL(3,2),
    is_preferred BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE maintenance_records (
    maintenance_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    maintenance_type_id INTEGER,
    service_provider_id INTEGER,
    scheduled_date DATE,
    completed_date DATE,
    odometer_at_service DECIMAL(12,2),
    cost DECIMAL(10,2),
    labor_hours DECIMAL(5,2),
    description TEXT,
    parts_used TEXT,
    technician_name VARCHAR(255),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    next_service_due_date DATE,
    next_service_due_miles DECIMAL(12,2),
    warranty_expiry_date DATE,
    invoice_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (maintenance_type_id) REFERENCES maintenance_types(maintenance_type_id),
    FOREIGN KEY (service_provider_id) REFERENCES service_providers(provider_id)
);

-- ========================================
-- 6. FUEL MANAGEMENT
-- ========================================

CREATE TABLE fuel_stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(255),
    address TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    brand VARCHAR(100),
    has_fleet_card BOOLEAN DEFAULT FALSE,
    avg_price_per_gallon DECIMAL(6,3)
);

CREATE TABLE fuel_transactions (
    transaction_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    driver_id INTEGER,
    fuel_station_id INTEGER,
    transaction_date TIMESTAMP NOT NULL,
    odometer_reading DECIMAL(12,2),
    gallons_purchased DECIMAL(8,3),
    price_per_gallon DECIMAL(6,3),
    total_amount DECIMAL(10,2),
    fuel_type VARCHAR(50),
    payment_method VARCHAR(20) DEFAULT 'fleet_card' CHECK (payment_method IN ('fleet_card', 'cash', 'credit', 'debit')),
    card_number_last_four VARCHAR(4),
    receipt_number VARCHAR(100),
    mpg_calculated DECIMAL(6,2),
    notes TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (fuel_station_id) REFERENCES fuel_stations(station_id)
);

-- ========================================
-- 7. TRIP AND ROUTE MANAGEMENT
-- ========================================

CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    driver_id INTEGER,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    start_location VARCHAR(255),
    end_location VARCHAR(255),
    start_odometer DECIMAL(12,2),
    end_odometer DECIMAL(12,2),
    distance_traveled DECIMAL(8,2),
    purpose VARCHAR(255),
    trip_type VARCHAR(20) DEFAULT 'business' CHECK (trip_type IN ('business', 'personal', 'maintenance', 'delivery', 'pickup')),
    fuel_consumed DECIMAL(8,3),
    average_speed DECIMAL(6,2),
    max_speed DECIMAL(6,2),
    idle_time_minutes INTEGER DEFAULT 0,
    harsh_braking_count INTEGER DEFAULT 0,
    harsh_acceleration_count INTEGER DEFAULT 0,
    speeding_violations INTEGER DEFAULT 0,
    route_efficiency_score DECIMAL(5,2),
    cost DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

CREATE TABLE gps_tracking (
    tracking_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    timestamp TIMESTAMP NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    speed DECIMAL(6,2),
    heading INTEGER,
    altitude DECIMAL(8,2),
    gps_quality VARCHAR(20) CHECK (gps_quality IN ('excellent', 'good', 'fair', 'poor')),
    engine_status VARCHAR(20) CHECK (engine_status IN ('on', 'off', 'idle')),
    fuel_level_percent DECIMAL(5,2),
    odometer DECIMAL(12,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- ========================================
-- 8. SAFETY AND INCIDENTS
-- ========================================

CREATE TABLE incidents (
    incident_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    driver_id INTEGER,
    incident_date TIMESTAMP NOT NULL,
    incident_type VARCHAR(20) NOT NULL CHECK (incident_type IN ('accident', 'violation', 'mechanical_failure', 'theft', 'vandalism', 'other')),
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('minor', 'moderate', 'major', 'critical')),
    location VARCHAR(255),
    description TEXT NOT NULL,
    police_report_number VARCHAR(100),
    insurance_claim_number VARCHAR(100),
    estimated_damage_cost DECIMAL(12,2),
    actual_repair_cost DECIMAL(12,2),
    injuries_reported BOOLEAN DEFAULT FALSE,
    fatalities BOOLEAN DEFAULT FALSE,
    at_fault BOOLEAN,
    weather_conditions VARCHAR(100),
    road_conditions VARCHAR(100),
    photos_available BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'reported' CHECK (status IN ('reported', 'under_investigation', 'resolved', 'closed')),
    resolution_date DATE,
    lessons_learned TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

CREATE TABLE safety_inspections (
    inspection_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    inspector_name VARCHAR(255),
    inspection_date DATE NOT NULL,
    inspection_type VARCHAR(20) NOT NULL CHECK (inspection_type IN ('routine', 'pre_trip', 'post_trip', 'annual', 'random')),
    odometer_reading DECIMAL(12,2),
    overall_score DECIMAL(5,2),
    passed BOOLEAN NOT NULL,
    defects_found INTEGER DEFAULT 0,
    critical_defects INTEGER DEFAULT 0,
    notes TEXT,
    next_inspection_due DATE,
    certificate_number VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

-- ========================================
-- 9. FINANCIAL MANAGEMENT
-- ========================================

CREATE TABLE cost_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER,
    driver_id INTEGER,
    category_id INTEGER,
    expense_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    description TEXT,
    vendor VARCHAR(255),
    invoice_number VARCHAR(100),
    receipt_available BOOLEAN DEFAULT FALSE,
    approved_by VARCHAR(255),
    approval_date DATE,
    reimbursable BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (category_id) REFERENCES cost_categories(category_id)
);

-- ========================================
-- 10. REPORTING AND ANALYTICS
-- ========================================

CREATE TABLE reports (
    report_id SERIAL PRIMARY KEY,
    company_id INTEGER,
    report_name VARCHAR(255) NOT NULL,
    report_type VARCHAR(20) NOT NULL CHECK (report_type IN ('fleet_utilization', 'cost_analysis', 'safety', 'maintenance', 'fuel_efficiency', 'driver_performance')),
    generated_by INTEGER,
    generation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_range_start DATE,
    date_range_end DATE,
    parameters JSON,
    file_path VARCHAR(500),
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('generating', 'completed', 'failed')),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (generated_by) REFERENCES users(user_id)
);

-- ========================================
-- SAMPLE DATA INSERTION
-- ========================================

-- Insert Companies
INSERT INTO companies (company_name, address, phone, email, contact_person, subscription_plan) VALUES
('TechFlow Logistics', '123 Innovation Drive, Tech City, TC 12345', '(555) 123-4567', 'fleet@techflow.com', 'Sarah Johnson', 'Enterprise'),
('Metro Delivery Services', '456 Commerce Ave, Business District, BD 67890', '(555) 234-5678', 'operations@metrodelivery.com', 'Mike Rodriguez', 'Professional'),
('Green Earth Transport', '789 Eco Boulevard, Sustainable City, SC 11111', '(555) 345-6789', 'info@greenearthtransport.com', 'Emily Chen', 'Professional'),
('City Wide Services', '321 Municipal Way, Downtown, DT 22222', '(555) 456-7890', 'fleet@citywide.com', 'David Thompson', 'Basic'),
('Rapid Express Co', '654 Speed Lane, Fast Track, FT 33333', '(555) 567-8901', 'dispatch@rapidexpress.com', 'Lisa Park', 'Enterprise');

-- Insert Departments
INSERT INTO departments (company_id, department_name, manager_name, budget) VALUES
(1, 'Logistics', 'James Wilson', 250000.00),
(1, 'Maintenance', 'Robert Garcia', 150000.00),
(1, 'Safety', 'Maria Lopez', 75000.00),
(2, 'Delivery Operations', 'John Smith', 180000.00),
(2, 'Fleet Management', 'Anna Brown', 120000.00),
(3, 'Transportation', 'Chris Davis', 200000.00),
(4, 'Municipal Services', 'Pat Johnson', 300000.00),
(5, 'Express Delivery', 'Sam Kim', 220000.00);

-- Insert Vehicle Types
INSERT INTO vehicle_types (type_name, description, fuel_efficiency_rating, capacity_passengers, capacity_cargo_cubic_feet) VALUES
('Cargo Van', 'Medium duty cargo van for deliveries', 18.5, 2, 250.0),
('Box Truck', 'Large cargo truck for heavy deliveries', 12.0, 3, 800.0),
('Pickup Truck', 'Light duty pickup truck', 22.0, 5, 65.0),
('Sedan', 'Passenger sedan for executive transport', 28.0, 5, 15.0),
('SUV', 'Sport utility vehicle for multiple purposes', 20.0, 7, 75.0),
('Semi Truck', 'Heavy duty long-haul truck', 6.5, 2, 2000.0),
('Refrigerated Truck', 'Temperature controlled delivery truck', 10.0, 2, 600.0);

-- Insert Users
INSERT INTO users (company_id, username, email, password_hash, first_name, last_name, role, phone) VALUES
(1, 'sjohnson', 'sarah.johnson@techflow.com', 'hash123', 'Sarah', 'Johnson', 'admin', '(555) 123-4567'),
(1, 'jwilson', 'james.wilson@techflow.com', 'hash456', 'James', 'Wilson', 'fleet_manager', '(555) 123-4568'),
(2, 'mrodriguez', 'mike.rodriguez@metrodelivery.com', 'hash789', 'Mike', 'Rodriguez', 'admin', '(555) 234-5678'),
(3, 'echen', 'emily.chen@greenearthtransport.com', 'hash321', 'Emily', 'Chen', 'admin', '(555) 345-6789'),
(4, 'dthompson', 'david.thompson@citywide.com', 'hash654', 'David', 'Thompson', 'fleet_manager', '(555) 456-7890');

-- Insert Drivers
INSERT INTO drivers (company_id, employee_id, first_name, last_name, license_number, license_class, license_expiry_date, date_of_birth, hire_date, phone, email, salary, safety_score, years_experience) VALUES
(1, 'EMP001', 'Michael', 'Johnson', 'DL123456789', 'CDL-A', '2025-08-15', '1985-03-20', '2022-01-15', '(555) 111-2222', 'mjohnson@techflow.com', 55000.00, 98.5, 8),
(1, 'EMP002', 'Jennifer', 'Williams', 'DL234567890', 'CDL-B', '2025-11-30', '1990-07-12', '2022-03-01', '(555) 111-3333', 'jwilliams@techflow.com', 52000.00, 95.2, 5),
(1, 'EMP003', 'Carlos', 'Martinez', 'DL345678901', 'CDL-A', '2026-02-28', '1988-11-05', '2021-09-10', '(555) 111-4444', 'cmartinez@techflow.com', 58000.00, 97.8, 7),
(2, 'EMP004', 'Ashley', 'Davis', 'DL456789012', 'Class C', '2025-09-20', '1992-01-18', '2023-02-15', '(555) 222-1111', 'adavis@metrodelivery.com', 45000.00, 92.1, 3),
(2, 'EMP005', 'Ryan', 'Taylor', 'DL567890123', 'CDL-B', '2025-12-10', '1987-05-22', '2022-06-01', '(555) 222-2222', 'rtaylor@metrodelivery.com', 50000.00, 89.7, 6),
(3, 'EMP006', 'Nicole', 'Anderson', 'DL678901234', 'CDL-A', '2026-01-15', '1989-09-30', '2021-11-20', '(555) 333-1111', 'nanderson@greenearthtransport.com', 56000.00, 96.3, 6),
(4, 'EMP007', 'Kevin', 'Brown', 'DL789012345', 'Class C', '2025-10-05', '1991-12-08', '2023-01-10', '(555) 444-1111', 'kbrown@citywide.com', 42000.00, 88.9, 2),
(5, 'EMP008', 'Rachel', 'Wilson', 'DL890123456', 'CDL-B', '2026-03-20', '1986-04-15', '2022-08-15', '(555) 555-1111', 'rwilson@rapidexpress.com', 53000.00, 94.6, 7);

-- Insert Vehicles
INSERT INTO vehicles (company_id, vehicle_type_id, vin, license_plate, make, model, year, color, fuel_type, purchase_date, purchase_price, current_value, odometer_reading, fuel_capacity, status, assigned_driver_id, department_id) VALUES
(1, 1, '1HGBH41JXMN109186', 'TFL001', 'Ford', 'Transit 250', 2022, 'White', 'gasoline', '2022-01-15', 35000.00, 28000.00, 45230.5, 25.0, 'active', 1, 1),
(1, 2, '1HGBH41JXMN109187', 'TFL002', 'Isuzu', 'NPR', 2021, 'White', 'diesel', '2021-06-10', 52000.00, 41000.00, 78945.2, 40.0, 'active', 2, 1),
(1, 6, '1HGBH41JXMN109188', 'TFL003', 'Freightliner', 'Cascadia', 2020, 'Blue', 'diesel', '2020-03-20', 125000.00, 95000.00, 245678.9, 150.0, 'active', 3, 1),
(2, 1, '1HGBH41JXMN109189', 'MDS001', 'Chevrolet', 'Express 2500', 2023, 'Yellow', 'gasoline', '2023-02-01', 38000.00, 35000.00, 12345.8, 31.0, 'active', 4, 4),
(2, 3, '1HGBH41JXMN109190', 'MDS002', 'Ford', 'F-150', 2022, 'Red', 'gasoline', '2022-08-15', 45000.00, 36000.00, 32156.4, 26.0, 'active', 5, 4),
(3, 7, '1HGBH41JXMN109191', 'GET001', 'Mercedes', 'Sprinter', 2021, 'Green', 'diesel', '2021-09-10', 75000.00, 58000.00, 67890.1, 24.5, 'active', 6, 6),
(4, 3, '1HGBH41JXMN109192', 'CWS001', 'Ram', '1500', 2023, 'White', 'gasoline', '2023-01-05', 42000.00, 39000.00, 8976.3, 26.0, 'active', 7, 7),
(5, 2, '1HGBH41JXMN109193', 'REC001', 'Hino', '195', 2022, 'Orange', 'diesel', '2022-05-20', 65000.00, 52000.00, 54321.7, 50.0, 'active', 8, 8);

-- Insert Maintenance Types
INSERT INTO maintenance_types (type_name, description, recommended_interval_miles, recommended_interval_months, estimated_cost) VALUES
('Oil Change', 'Regular engine oil and filter change', 5000, 6, 75.00),
('Tire Rotation', 'Rotate tires for even wear', 7500, 6, 50.00),
('Brake Inspection', 'Inspect brake pads and rotors', 15000, 12, 125.00),
('Annual DOT Inspection', 'Department of Transportation safety inspection', 0, 12, 200.00),
('Transmission Service', 'Transmission fluid change and inspection', 30000, 24, 300.00),
('Engine Tune-up', 'Comprehensive engine maintenance', 50000, 36, 450.00),
('Cooling System Service', 'Coolant flush and system inspection', 30000, 24, 175.00);

-- Insert Service Providers
INSERT INTO service_providers (company_id, provider_name, service_type, contact_person, phone, email, hourly_rate, rating, is_preferred) VALUES
(1, 'Premier Auto Service', 'maintenance', 'Tom Anderson', '(555) 800-1111', 'service@premierauto.com', 85.00, 4.8, TRUE),
(1, 'Fleet Maintenance Pro', 'repair', 'Linda Rogers', '(555) 800-2222', 'repairs@fleetmaintpro.com', 95.00, 4.6, TRUE),
(2, 'Metro Truck Center', 'maintenance', 'Bob Mitchell', '(555) 800-3333', 'service@metrotruck.com', 90.00, 4.5, FALSE),
(3, 'Green Auto Care', 'maintenance', 'Susan Green', '(555) 800-4444', 'info@greenautocare.com', 80.00, 4.9, TRUE),
(4, 'City Garage Services', 'repair', 'Mark Johnson', '(555) 800-5555', 'repairs@citygarage.com', 75.00, 4.2, FALSE);

-- Insert Fuel Stations
INSERT INTO fuel_stations (station_name, address, latitude, longitude, brand, has_fleet_card, avg_price_per_gallon) VALUES
('Shell Station #1', '100 Main St, Tech City, TC', 40.7128, -74.0060, 'Shell', TRUE, 3.45),
('BP Truck Stop', '200 Highway 95, Business District, BD', 40.7589, -73.9851, 'BP', TRUE, 3.42),
('Exxon Fleet Center', '300 Industrial Blvd, Sustainable City, SC', 40.7831, -73.9712, 'Exxon', TRUE, 3.48),
('Chevron Station', '400 Commerce Way, Downtown, DT', 40.7505, -73.9934, 'Chevron', FALSE, 3.52),
('Speedway Express', '500 Fast Lane, Fast Track, FT', 40.7282, -74.0776, 'Speedway', TRUE, 3.41);

-- Insert Sample Maintenance Records
INSERT INTO maintenance_records (vehicle_id, maintenance_type_id, service_provider_id, scheduled_date, completed_date, odometer_at_service, cost, labor_hours, description, status, next_service_due_miles) VALUES
(1, 1, 1, '2024-01-15', '2024-01-15', 40000.0, 78.50, 0.5, 'Regular oil change with synthetic oil', 'completed', 45000.0),
(1, 2, 1, '2024-02-01', '2024-02-01', 42500.0, 52.00, 0.75, 'Tire rotation and pressure check', 'completed', 50000.0),
(2, 1, 1, '2024-01-20', '2024-01-20', 75000.0, 125.00, 1.0, 'Oil change for diesel engine', 'completed', 80000.0),
(3, 4, 2, '2024-03-01', '2024-03-01', 240000.0, 195.00, 2.0, 'Annual DOT inspection - passed', 'completed', 0),
(4, 1, 3, '2024-01-25', '2024-01-25', 10000.0, 82.00, 0.5, 'First oil change for new vehicle', 'completed', 15000.0);

-- Insert Sample Fuel Transactions
INSERT INTO fuel_transactions (vehicle_id, driver_id, fuel_station_id, transaction_date, odometer_reading, gallons_purchased, price_per_gallon, total_amount, fuel_type, payment_method, mpg_calculated) VALUES
(1, 1, 1, '2024-05-20 08:30:00', 45100.0, 18.5, 3.45, 63.83, 'Regular', 'fleet_card', 22.3),
(1, 1, 2, '2024-05-18 14:15:00', 44850.0, 16.2, 3.42, 55.40, 'Regular', 'fleet_card', 21.8),
(2, 2, 2, '2024-05-19 10:45:00', 78800.0, 32.1, 3.88, 124.55, 'Diesel', 'fleet_card', 12.5),
(3, 3, 3, '2024-05-21 16:20:00', 245500.0, 125.0, 3.92, 490.00, 'Diesel', 'fleet_card', 6.8),
(4, 4, 1, '2024-05-22 09:10:00', 12200.0, 22.3, 3.45, 76.94, 'Regular', 'fleet_card', 19.2);

-- Insert Sample Trips
INSERT INTO trips (vehicle_id, driver_id, start_time, end_time, start_location, end_location, start_odometer, end_odometer, distance_traveled, purpose, trip_type, fuel_consumed, average_speed, harsh_braking_count, harsh_acceleration_count, route_efficiency_score) VALUES
(1, 1, '2024-05-22 08:00:00', '2024-05-22 17:30:00', 'TechFlow Depot', 'Client Site Downtown', 45100.0, 45250.0, 150.0, 'Client delivery', 'business', 6.8, 45.2, 0, 1, 95.5),
(1, 1, '2024-05-21 09:15:00', '2024-05-21 16:45:00', 'TechFlow Depot', 'Warehouse District', 44950.0, 45100.0, 150.0, 'Pickup supplies', 'business', 7.2, 42.8, 2, 0, 92.3),
(2, 2, '2024-05-20 07:30:00', '2024-05-20 18:00:00', 'TechFlow Depot', 'Multiple delivery stops', 78600.0, 78800.0, 200.0, 'Daily delivery route', 'business', 16.5, 38.5, 1, 2, 88.7),
(3, 3, '2024-05-19 06:00:00', '2024-05-21 20:00:00', 'TechFlow Depot', 'Cross-country delivery', 245000.0, 245500.0, 500.0, 'Long haul delivery', 'business', 75.2, 62.5, 0, 0, 97.8),
(4, 4, '2024-05-22 10:00:00', '2024-05-22 15:30:00', 'Metro Depot', 'City Center', 12150.0, 12200.0, 50.0, 'Package delivery', 'business', 2.8, 28.3, 1, 1, 85.2),
(5, 5, '2024-05-21 11:20:00', '2024-05-21 14:45:00', 'Metro Depot', 'Suburban area', 32100.0, 32156.0, 56.0, 'Residential delivery', 'business', 2.9, 32.1, 0, 0, 91.4);

-- Insert Sample Incidents
INSERT INTO incidents (vehicle_id, driver_id, incident_date, incident_type, severity, location, description, estimated_damage_cost, at_fault, weather_conditions, status) VALUES
(1, 1, '2024-03-15 14:30:00', 'accident', 'minor', 'Main St & 5th Ave', 'Minor fender bender in parking lot. Scratched rear bumper.', 850.00, FALSE, 'Clear', 'resolved'),
(2, 2, '2024-04-22 09:15:00', 'violation', 'minor', 'Highway 95', 'Speeding ticket - 10 mph over limit in construction zone', 250.00, TRUE, 'Clear', 'closed'),
(4, 4, '2024-05-10 16:45:00', 'mechanical_failure', 'moderate', 'Downtown delivery route', 'Alternator failure causing vehicle breakdown', 450.00, NULL, 'Rainy', 'resolved');

-- Insert Sample Safety Inspections
INSERT INTO safety_inspections (vehicle_id, inspector_name, inspection_date, inspection_type, odometer_reading, overall_score, passed, defects_found, notes) VALUES
(1, 'John Safety Inspector', '2024-01-15', 'annual', 40000.0, 95.5, TRUE, 1, 'Minor issue with windshield wiper - replaced'),
(2, 'Mary DOT Inspector', '2024-02-01', 'annual', 75000.0, 98.2, TRUE, 0, 'Excellent condition, all systems operational'),
(3, 'Robert State Inspector', '2024-03-01', 'annual', 240000.0, 92.8, TRUE, 2, 'Tire tread depth borderline, brake pads 40% remaining'),
(4, 'Lisa Fleet Inspector', '2024-01-25', 'routine', 10000.0, 99.1, TRUE, 0, 'New vehicle inspection - perfect condition'),
(5, 'Dave Safety Tech', '2024-02-15', 'routine', 30000.0, 89.5, TRUE, 3, 'Multiple minor issues: worn belts, low fluid levels');

-- Insert Cost Categories
INSERT INTO cost_categories (category_name, description) VALUES
('Fuel', 'Gasoline, diesel, and other fuel costs'),
('Maintenance', 'Routine maintenance and repairs'),
('Insurance', 'Vehicle insurance premiums'),
('Registration', 'Vehicle registration and licensing fees'),
('Tolls', 'Highway and bridge tolls'),
('Parking', 'Parking fees and permits'),
('Violations', 'Traffic tickets and fines'),
('Equipment', 'Vehicle equipment and accessories'),
('Training', 'Driver training and certification'),
('Other', 'Miscellaneous fleet-related expenses');

-- Insert Sample Expenses
INSERT INTO expenses (vehicle_id, driver_id, category_id, expense_date, amount, description, vendor, reimbursable) VALUES
(1, 1, 1, '2024-05-20', 63.83, 'Fuel purchase - Shell Station', 'Shell', FALSE),
(1, 1, 2, '2024-01-15', 78.50, 'Oil change and filter', 'Premier Auto Service', FALSE),
(2, 2, 1, '2024-05-19', 124.55, 'Diesel fuel purchase', 'BP Truck Stop', FALSE),
(3, 3, 2, '2024-03-01', 195.00, 'Annual DOT inspection', 'Fleet Maintenance Pro', FALSE),
(4, 4, 5, '2024-05-15', 12.50, 'Bridge toll - downtown route', 'City Bridge Authority', TRUE),
(1, 1, 7, '2024-04-22', 250.00, 'Speeding violation fine', 'State Traffic Court', FALSE),
(5, 5, 6, '2024-05-18', 25.00, 'Daily parking downtown', 'City Parking Authority', TRUE);

-- Insert Driver Certifications
INSERT INTO driver_certifications (driver_id, certification_name, issuing_authority, issue_date, expiry_date, certification_number) VALUES
(1, 'Hazmat Endorsement', 'Department of Transportation', '2023-01-15', '2026-01-15', 'HM123456'),
(1, 'Defensive Driving Certificate', 'National Safety Council', '2024-02-01', '2027-02-01', 'DD789012'),
(3, 'Hazmat Endorsement', 'Department of Transportation', '2022-06-10', '2025-06-10', 'HM234567'),
(3, 'Long Haul Certification', 'Trucking Safety Institute', '2023-03-15', '2026-03-15', 'LH345678'),
(6, 'Refrigeration Transport Cert', 'Cold Chain Institute', '2023-09-20', '2025-09-20', 'RC456789'),
(8, 'Express Delivery Certification', 'Rapid Transport Academy', '2024-01-10', '2026-01-10', 'ED567890');

-- Insert Sample GPS Tracking Data (Recent data)
INSERT INTO gps_tracking (vehicle_id, timestamp, latitude, longitude, speed, heading, engine_status, fuel_level_percent, odometer) VALUES
(1, '2024-05-25 10:30:00', 40.7128, -74.0060, 35.5, 90, 'on', 75.2, 45250.5),
(1, '2024-05-25 10:31:00', 40.7129, -74.0055, 38.2, 95, 'on', 75.1, 45250.8),
(1, '2024-05-25 10:32:00', 40.7130, -74.0050, 42.1, 100, 'on', 75.0, 45251.2),
(2, '2024-05-25 10:30:00', 40.7589, -73.9851, 28.7, 180, 'on', 68.5, 78801.3),
(2, '2024-05-25 10:31:00', 40.7585, -73.9851, 31.2, 185, 'on', 68.4, 78801.7),
(3, '2024-05-25 10:30:00', 40.7831, -73.9712, 65.8, 270, 'on', 45.8, 245501.2),
(4, '2024-05-25 10:30:00', 40.7505, -73.9934, 0.0, 0, 'idle', 82.1, 12200.3),
(5, '2024-05-25 10:30:00', 40.7282, -74.0776, 25.3, 45, 'on', 91.7, 32157.1);

-- Insert Sample Reports
INSERT INTO reports (company_id, report_name, report_type, generated_by, date_range_start, date_range_end, status) VALUES
(1, 'Monthly Fleet Utilization - May 2024', 'fleet_utilization', 1, '2024-05-01', '2024-05-31', 'completed'),
(1, 'Q1 2024 Cost Analysis', 'cost_analysis', 2, '2024-01-01', '2024-03-31', 'completed'),
(2, 'Driver Safety Report - April 2024', 'safety', 3, '2024-04-01', '2024-04-30', 'completed'),
(3, 'Fuel Efficiency Analysis Q1 2024', 'fuel_efficiency', 4, '2024-01-01', '2024-03-31', 'completed'),
(1, 'Maintenance Schedule Report', 'maintenance', 2, '2024-05-01', '2024-12-31', 'completed');

-- Insert Vehicle Assignments
INSERT INTO vehicle_assignments (vehicle_id, driver_id, assigned_date, assignment_type, is_active) VALUES
(1, 1, '2022-01-15', 'permanent', TRUE),
(2, 2, '2022-03-01', 'permanent', TRUE),
(3, 3, '2021-09-10', 'permanent', TRUE),
(4, 4, '2023-02-15', 'permanent', TRUE),
(5, 5, '2022-06-01', 'permanent', TRUE),
(6, 6, '2021-11-20', 'permanent', TRUE),
(7, 7, '2023-01-10', 'permanent', TRUE),
(8, 8, '2022-08-15', 'permanent', TRUE);

-- ========================================
-- USEFUL VIEWS FOR REPORTING
-- ========================================

-- Fleet Overview View
CREATE OR REPLACE VIEW fleet_overview AS
SELECT 
    v.vehicle_id,
    v.license_plate,
    v.make,
    v.model,
    v.year,
    v.status,
    CONCAT(d.first_name, ' ', d.last_name) AS assigned_driver,
    v.odometer_reading,
    vt.type_name AS vehicle_type,
    c.company_name
FROM vehicles v
LEFT JOIN drivers d ON v.assigned_driver_id = d.driver_id
LEFT JOIN vehicle_types vt ON v.vehicle_type_id = vt.type_id
LEFT JOIN companies c ON v.company_id = c.company_id;

-- Driver Performance View
CREATE OR REPLACE VIEW driver_performance AS
SELECT 
    d.driver_id,
    CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
    d.safety_score,
    d.years_experience,
    COUNT(DISTINCT t.trip_id) AS total_trips,
    SUM(t.distance_traveled) AS total_distance,
    AVG(t.average_speed) AS avg_speed,
    SUM(t.harsh_braking_count) AS total_harsh_braking,
    SUM(t.harsh_acceleration_count) AS total_harsh_acceleration,
    COUNT(i.incident_id) AS incident_count
FROM drivers d
LEFT JOIN trips t ON d.driver_id = t.driver_id
LEFT JOIN incidents i ON d.driver_id = i.driver_id
WHERE d.status = 'active'
GROUP BY d.driver_id, d.first_name, d.last_name, d.safety_score, d.years_experience;

-- Vehicle Maintenance Summary View
CREATE OR REPLACE VIEW maintenance_summary AS
SELECT 
    v.vehicle_id,
    v.license_plate,
    v.make,
    v.model,
    COUNT(mr.maintenance_id) AS total_services,
    SUM(mr.cost) AS total_maintenance_cost,
    MAX(mr.completed_date) AS last_service_date,
    MIN(mr.next_service_due_date) AS next_service_due
FROM vehicles v
LEFT JOIN maintenance_records mr ON v.vehicle_id = mr.vehicle_id
WHERE mr.status = 'completed'
GROUP BY v.vehicle_id, v.license_plate, v.make, v.model;

-- Fuel Efficiency Analysis View
CREATE OR REPLACE VIEW fuel_efficiency AS
SELECT 
    v.vehicle_id,
    v.license_plate,
    v.make,
    v.model,
    COUNT(ft.transaction_id) AS fuel_transactions,
    SUM(ft.gallons_purchased) AS total_gallons,
    SUM(ft.total_amount) AS total_fuel_cost,
    AVG(ft.price_per_gallon) AS avg_price_per_gallon,
    AVG(ft.mpg_calculated) AS avg_mpg,
    SUM(t.distance_traveled) AS total_distance
FROM vehicles v
LEFT JOIN fuel_transactions ft ON v.vehicle_id = ft.vehicle_id
LEFT JOIN trips t ON v.vehicle_id = t.vehicle_id
GROUP BY v.vehicle_id, v.license_plate, v.make, v.model;

-- Cost Analysis View
CREATE OR REPLACE VIEW cost_analysis AS
SELECT 
    v.vehicle_id,
    v.license_plate,
    cc.category_name,
    SUM(e.amount) AS total_cost,
    COUNT(e.expense_id) AS expense_count,
    AVG(e.amount) AS avg_expense
FROM vehicles v
LEFT JOIN expenses e ON v.vehicle_id = e.vehicle_id
LEFT JOIN cost_categories cc ON e.category_id = cc.category_id
GROUP BY v.vehicle_id, v.license_plate, cc.category_name;

-- ========================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ========================================

-- Primary performance indexes
CREATE INDEX idx_vehicles_company_status ON vehicles(company_id, status);
CREATE INDEX idx_drivers_company_status ON drivers(company_id, status);
CREATE INDEX idx_trips_vehicle_date ON trips(vehicle_id, start_time);
CREATE INDEX idx_fuel_transactions_vehicle_date ON fuel_transactions(vehicle_id, transaction_date);
CREATE INDEX idx_maintenance_vehicle_date ON maintenance_records(vehicle_id, completed_date);
CREATE INDEX idx_expenses_vehicle_date ON expenses(vehicle_id, expense_date);
CREATE INDEX idx_incidents_vehicle_date ON incidents(vehicle_id, incident_date);
CREATE INDEX idx_gps_tracking_vehicle_timestamp ON gps_tracking(vehicle_id, timestamp);

-- Reporting indexes
CREATE INDEX idx_reports_company_type ON reports(company_id, report_type);
CREATE INDEX idx_users_company_role ON users(company_id, role);