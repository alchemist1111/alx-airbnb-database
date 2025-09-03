-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings
SELECT
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    b.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id 

-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties with no reviews
SELECT
    p.property_id,
    p.name AS property_name,
    p.location,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id  

-- 3. FULL OUTER JOIN: Retrieve all users and all bookings,
-- even if the user has no booking or the booking is not linked to a user
-- NOTE: MySQL doesn’t support FULL OUTER JOIN directly. 
-- We simulate it using UNION of LEFT and RIGHT JOIN.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id

UNION

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status
FROM User u
RIGHT JOIN Booking b ON u.user_id = b.user_id


