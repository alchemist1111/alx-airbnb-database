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
