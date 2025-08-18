-- Generate sample time-series data for batch process
USE BatchDB;
GO

-- Clear existing data
DELETE FROM batch_data;
GO

-- Generate realistic batch process data with time series (every second for 5 minutes)
DECLARE @BatchNumber NVARCHAR(50) = 'B001';
DECLARE @ProductName NVARCHAR(100) = 'Chemical Product A';
DECLARE @StartTime DATETIME2 = DATEADD(HOUR, -1, GETDATE());
DECLARE @Counter INT = 1;
DECLARE @MaxSeconds INT = 300; -- 5 minutes of data

WHILE @Counter <= @MaxSeconds
BEGIN
    INSERT INTO batch_data (
        batch_number, 
        product_name, 
        temperature, 
        pressure, 
        flow_rate, 
        ph_level, 
        timer_value, 
        state, 
        created_at
    )
    VALUES (
        @BatchNumber,
        @ProductName,
        -- Temperature varies between 70-80°C with some fluctuation
        70 + (RAND() * 10) + SIN(@Counter * 0.1) * 2,
        -- Pressure varies between 2.0-3.5 bar
        2.0 + (RAND() * 1.5) + COS(@Counter * 0.05) * 0.3,
        -- Flow rate varies between 10-20 L/min
        10 + (RAND() * 10) + SIN(@Counter * 0.08) * 1.5,
        -- pH level varies between 6.5-7.5
        6.5 + (RAND() * 1.0) + SIN(@Counter * 0.03) * 0.2,
        -- Timer counts down from 300 to 0
        @MaxSeconds - @Counter + 1,
        -- State changes based on timer
        CASE 
            WHEN @Counter <= 60 THEN 'starting'
            WHEN @Counter <= 240 THEN 'running'
            WHEN @Counter <= 290 THEN 'finishing'
            ELSE 'completed'
        END,
        DATEADD(SECOND, @Counter, @StartTime)
    );
    
    SET @Counter = @Counter + 1;
END;

-- Generate another batch with different characteristics
SET @BatchNumber = 'B002';
SET @ProductName = 'Chemical Product B';
SET @StartTime = DATEADD(HOUR, -2, GETDATE());
SET @Counter = 1;
SET @MaxSeconds = 180; -- 3 minutes of data

WHILE @Counter <= @MaxSeconds
BEGIN
    INSERT INTO batch_data (
        batch_number, 
        product_name, 
        temperature, 
        pressure, 
        flow_rate, 
        ph_level, 
        timer_value, 
        state, 
        created_at
    )
    VALUES (
        @BatchNumber,
        @ProductName,
        -- Different temperature range 85-95°C
        85 + (RAND() * 10) + SIN(@Counter * 0.12) * 1.5,
        -- Different pressure range 3.0-4.5 bar
        3.0 + (RAND() * 1.5) + COS(@Counter * 0.07) * 0.4,
        -- Different flow rate 15-25 L/min
        15 + (RAND() * 10) + SIN(@Counter * 0.09) * 2,
        -- pH level varies between 7.0-8.0
        7.0 + (RAND() * 1.0) + SIN(@Counter * 0.04) * 0.3,
        -- Timer counts down
        @MaxSeconds - @Counter + 1,
        -- State changes
        CASE 
            WHEN @Counter <= 30 THEN 'starting'
            WHEN @Counter <= 150 THEN 'running'
            WHEN @Counter <= 170 THEN 'finishing'
            ELSE 'completed'
        END,
        DATEADD(SECOND, @Counter, @StartTime)
    );
    
    SET @Counter = @Counter + 1;
END;

-- Display summary
SELECT 
    batch_number,
    product_name,
    COUNT(*) as data_points,
    MIN(created_at) as start_time,
    MAX(created_at) as end_time,
    AVG(temperature) as avg_temp,
    AVG(pressure) as avg_pressure,
    AVG(flow_rate) as avg_flow_rate,
    AVG(ph_level) as avg_ph
FROM batch_data 
GROUP BY batch_number, product_name
ORDER BY batch_number;

PRINT 'Sample data generated successfully!';
GO