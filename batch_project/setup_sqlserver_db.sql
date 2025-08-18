-- Create database
CREATE DATABASE BatchDB;
GO

USE BatchDB;
GO

-- Create table
CREATE TABLE batch_data (
    id INT IDENTITY(1,1) PRIMARY KEY,
    batch_number NVARCHAR(50) NOT NULL,
    product_name NVARCHAR(100) NOT NULL,
    temperature FLOAT NOT NULL,
    pressure FLOAT NOT NULL,
    flow_rate FLOAT NOT NULL,
    ph_level FLOAT NOT NULL,
    timer_value INT NOT NULL,
    state NVARCHAR(20) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- Insert sample data
INSERT INTO batch_data (batch_number, product_name, temperature, pressure, flow_rate, ph_level, timer_value, state)
VALUES ('B001', 'Sample Product', 75.5, 2.3, 15.2, 7.1, 300, 'completed');
GO