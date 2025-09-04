-- Indexes for User table
-- Email is frequently used in WHERE and JOIN clauses (e.g., login, lookups)
CREATE INDEX idx_user_email ON User(email);

-- Role is often used for filtering (guest, host, admin)
CREATE INDEX idx_user_role ON User(role);


-- Indexes for Booking table
-- Foreign keys are often joined in queries
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_property ON Booking(property_id);

-- Status is commonly queried in WHERE clauses (pending, confirmed, canceled)
CREATE INDEX idx_booking_status ON Booking(status);

-- Date ranges are used in availability searches
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);


-- Indexes for Property table
-- Host lookup (joins between host and properties)
CREATE INDEX idx_property_host ON Property(host_id);

-- Location searches
CREATE INDEX idx_property_location ON Property(location);

-- Price filter (range queries for search results)
CREATE INDEX idx_property_price ON Property(pricepernight);


-- Performance Checks with EXPLAIN ANALYZE

-- 1. User lookup by email
EXPLAIN ANALYZE
SELECT * FROM User WHERE email = 'john@example.com';

-- 2. Booking history for a user
EXPLAIN ANALYZE
SELECT * FROM Booking WHERE user_id = '123e4567-e89b-12d3-a456-426614174000';

-- 3. Properties in a city
EXPLAIN ANALYZE
SELECT * FROM Property WHERE location = 'Nairobi';
