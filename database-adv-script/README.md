# Airbnb Database - Advanced Join Queries

This project demonstrates the use of **SQL JOINs** on the Airbnb schema.  
We use INNER JOIN, LEFT JOIN, and FULL OUTER JOIN to explore relationships between Users, Bookings, Properties, and Reviews.

---

## Task 0

## Queries

### 1. INNER JOIN – Bookings with respective Users
```sql
SELECT b.booking_id, b.property_id, b.start_date, b.end_date, b.status,
       u.user_id, u.first_name, u.last_name, u.email
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id;

📌 Retrieves only users who made bookings and their booking details.

SELECT p.property_id, p.name AS property_name, p.location,
       r.review_id, r.rating, r.comment, r.created_at
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id;

📌 Retrieves all properties and their reviews. If a property has no review, review fields will show NULL.

SELECT u.user_id, u.first_name, u.last_name,
       b.booking_id, b.property_id, b.start_date, b.end_date, b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id

UNION

SELECT u.user_id, u.first_name, u.last_name,
       b.booking_id, b.property_id, b.start_date, b.end_date, b.status
FROM User u
RIGHT JOIN Booking b ON u.user_id = b.user_id;

📌 Retrieves all users (even those without bookings) and all bookings (even if not linked to a user).
Since MySQL doesn’t support FULL OUTER JOIN directly, we simulate it using UNION of LEFT JOIN and RIGHT JOIN.


```
## Task 1: Practice Subqueries
This task demonstrates the use of **non-correlated** and **correlated subqueries** on the Airbnb schema.

---

## Queries
### 1. Non-correlated Subquery – Properties with Average Rating > 4.0

```sql
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.property_id;

📌 Retrieves all properties whose average rating (from the Review table) is greater than 4.0.
This is non-correlated because the inner query runs independently of the outer query.

SELECT u.user_id, u.first_name, u.last_name, u.email
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3
ORDER BY u.user_id;

📌 Retrieves all users who have made more than 3 bookings.
This is a correlated subquery because the inner query references the outer query (u.user_id).

```
## Task 2: Aggregations and Window Functions

This task demonstrates how to use **aggregation functions** and **window functions** on the Airbnb schema.

---

## Queries

### 1. Aggregation – Total Bookings per User
```sql
SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;

📌 This query counts the number of bookings made by each user using the COUNT function and GROUP BY.
We use a LEFT JOIN so users with zero bookings are still included.


SELECT p.property_id, p.name, COUNT(b.booking_id) AS total_bookings,
       RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY booking_rank;
```

📌 This query uses RANK() as a window function to rank properties by how many bookings they have received.

- **COUNT(b.booking_id)** gives total bookings.

- **RANK()** OVER (ORDER BY COUNT(...) DESC) ranks properties from most to least booked.


### Task 3: Index Optimization

This task focuses on **improving query performance** in the Airbnb schema using indexes.  
We created indexes on frequently queried columns from the **User**, **Booking**, and **Property** tables.

---

## Indexes Created

### User Table
- `idx_user_email` → speeds up login and lookup by email.
- `idx_user_role` → optimizes queries filtering by role (guest, host, admin).

### Booking Table
- `idx_booking_user` → improves JOIN performance between users and bookings.
- `idx_booking_property` → improves JOIN performance between properties and bookings.
- `idx_booking_status` → speeds up queries filtering by booking status.
- `idx_booking_dates` → optimizes availability checks and date range queries.

### Property Table
- `idx_property_host` → speeds up lookups for properties belonging to a specific host.
- `idx_property_location` → optimizes search by location.
- `idx_property_price` → improves range queries for price filtering.

---

## Performance Analysis
I used `EXPLAIN` to compare query execution **before and after adding indexes**.

### Example 1: User lookup by email
```sql
EXPLAIN SELECT * FROM User WHERE email = 'john@example.com';
```

- **Before index** → Full table scan (ALL).

- **After index (idx_user_email)** → Uses index scan (ref), reducing execution time significantly.

### Example 2: Booking history for a user
```sql
EXPLAIN SELECT * FROM Booking WHERE user_id = '123e4567-e89b-12d3-a456-426614174000';
```
- **Before index** → Full table scan on Booking.

- **After index (idx_booking_user)** → Index lookup, direct access to matching rows.

### Example 3: Properties in a city
```sql
EXPLAIN SELECT * FROM Property WHERE location = 'Nairobi';
```
- **Before index** → Full table scan.

- **After index (idx_property_location)** → Index range scan.

