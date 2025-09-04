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