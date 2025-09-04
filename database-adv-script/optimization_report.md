# Airbnb Database - Query Optimization Report

This task demonstrates how to optimize a **complex query** that retrieves bookings with user, property, and payment details.

---

## Step 1: Initial Query
```sql
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.status,
       u.user_id, u.first_name, u.last_name, u.email,
       p.property_id, p.name AS property_name, p.location,
       pay.payment_id, pay.amount, pay.payment_method, pay.payment_date
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;
```

### Analysis
- **Findings** from EXPLAIN:

   - **Multiple** full table scans (especially on User, Property, and Payment if not indexed).

   - **Retrieves** unnecessary columns (user_id, property_id, payment_id) when names/details are sufficient.

   - **Joins** are correct but not all columns are needed.

## Step 2: Refactored Query 
```sql
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.status,
       u.first_name, u.last_name,
       p.name AS property_name,
       pay.amount, pay.payment_method
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;
```