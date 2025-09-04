-- Drop existing partitioned table if it exists (for reruns)
DROP TABLE IF EXISTS Booking_Partitioned;

-- Create a partitioned version of the Booking table based on start_date
CREATE TABLE Booking_Partitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

-- Insert data from the original Booking table (simulation of migration)
INSERT INTO Booking_Partitioned
SELECT * FROM Booking;


-- Test query performance with partition pruning (fetch bookings by year range)
EXPLAIN ANALYZE
SELECT * 
FROM Booking_Partitioned
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';
