# Airbnb Database - Partitioning Performance Report

This task demonstrates **table partitioning** on the `Booking` table to improve query performance when dealing with large datasets.

---

## Step 1: Partitioning Strategy
- We partitioned the `Booking` table by **year of `start_date`** using `RANGE` partitioning.
- Partitions created:
  - `p2022` → Bookings before 2023
  - `p2023` → Bookings in 2023
  - `p2024` → Bookings in 2024
  - `pmax` → Future bookings

---

## Step 2: Test Query
```sql
EXPLAIN ANALYZE
SELECT * 
FROM Booking_Partitioned
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';
```

### Observations
- **Before** partitioning: The query scanned the entire Booking table, even for a specific date range.

- **After** partitioning: The query used partition pruning, scanning only the p2023 partition.

- **Execution** time dropped significantly on large datasets since irrelevant partitions were skipped.

## Step 3: Benefits
- **Faster range queries:** Partition pruning reduces the amount of data scanned.

- **Better maintenance:** Old partitions can be archived or dropped without affecting current data.

- **Scalability:** Supports growing datasets by adding new partitions (e.g., p2025).

## Step 4: Trade-offs
- **Partitioning** adds complexity in schema design and data migration.

- **Not all queries benefit** — performance gains are most noticeable on range queries involving start_date.