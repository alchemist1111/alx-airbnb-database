## Airbnb Database Schema — Normalised to 3NF
### 📦 Directory: database-script-0x01
This module defines the Airbnb database schema using SQL. It applies normalization principles to ensure the design is in Third Normal Form (3NF).

### 🧱 Tables Defined
**User: Stores user profiles and roles.
**Property: Listings created by hosts.
**Booking: Reservation details.
**Payment: Linked to bookings.
**Review: Feedback from guests.
**Message: Communication between users.
### ✅ Normalisation Summary
### First Normal Form (1NF)
**All fields are atomic.
**No repeating groups.
### Second Normal Form (2NF)
**All non-key attributes fully depend on the primary key.
### Third Normal Form (3NF)
**No transitive dependencies.
**Derived fields like total_price are excluded from base tables.
**💡 total_price can be calculated dynamically as: DATEDIFF(end_date, start_date) × Property.pricepernight

### 🔐 Constraints & Indexes
**Primary and foreign keys enforce referential integrity.
**ENUMs restrict values for roles, status, and payment methods.
**Indexes added for high-traffic columns (e.g., email, property_id, booking_id).
### 🧠 Notes
**UUIDs used for global uniqueness.
**Timestamp fields track creation and updates.
**Schema is optimized for scalability and clarity.