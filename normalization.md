## Airbnb Database Normalisation to Third Normal Form (3NF)
### 🎯 Objective
**Apply normalisation principles to ensure the Airbnb database schema is in Third Normal Form (3NF) by eliminating redundancy, ensuring data integrity, and optimizing relational structure.

### 🧠 Normalisation Overview
#### First Normal Form (1NF)
Ensures atomicity: all fields contain indivisible values.
✅ All tables in the schema meet 1NF.
#### Second Normal Form (2NF)
Achieved when:
The table is in 1NF.
All non-key attributes are fully functionally dependent on the entire primary key.
✅ All tables with composite keys (e.g., none in this schema) are properly structured.
#### Third Normal Form (3NF)
Achieved when:
The table is in 2NF.
There are no transitive dependencies (i.e., non-key attributes do not depend on other non-key attributes).
### 🔍 Schema Review and Adjustments
✅ User
Already in 3NF.
No transitive dependencies.
role is atomic and ENUM is acceptable.
✅ Property
Already in 3NF.
host_id references User, no derived or redundant fields.
⚠️ Booking
Potential issue: total_price is derived from pricepernight × number_of_nights.
❗ Fix: Remove total_price from Booking and calculate it dynamically or move to a derived view.
✅ Payment
No transitive dependencies.
Each payment is tied to a booking.
✅ Review
No transitive dependencies.
rating and comment are directly related to the review.
✅ Message
No transitive dependencies.
sender_id and recipient_id are atomic foreign keys.
### ✅ Final Adjusted Schema Summary
#### Booking (Adjusted)
```bash
booking_id UUID PRIMARY KEY,
property_id UUID FOREIGN KEY REFERENCES Property(property_id),
user_id UUID FOREIGN KEY REFERENCES User(user_id),
start_date DATE NOT NULL,
end_date DATE NOT NULL,
status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- Removed total_price
```