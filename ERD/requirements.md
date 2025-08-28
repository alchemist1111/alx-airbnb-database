Project "Air BnB ERD" {
    database_type: 'PostgreSQL' 
}

// Enums
Enum user_role {
  guest
  host
  admin
}

Enum booking_status {
  pending
  confirmed
  cancelled
}

Enum payment_method {
  credit_card
  paypal
  stripe
}

// Tables
Table users {
  user_id  uuid [pk, note: 'primary key, UUID' ]
  first_name varchar [not null]
  last_name varchar [not null]
  email varchar [not null, unique, note: 'Unique constraint on email']
  password_hash  varchar    [not null]
  phone_number   varchar
  role           user_role  [not null]
  created_at     timestamp  [not null, default: `CURRENT_TIMESTAMP`]

   Indexes {
    (email) [unique, name: 'idx_users_email']
  }
}

Table properties {
  property_id    uuid       [pk, note: 'Primary Key, UUID']
  host_id        uuid       [not null, note: 'FK -> users.user_id (host)']
  name           varchar    [not null]
  description    text       [not null]
  location       varchar    [not null]
  pricepernight  decimal    [not null]
  created_at     timestamp  [not null, default: `CURRENT_TIMESTAMP`]
  updated_at     timestamp  [note: 'ON UPDATE CURRENT_TIMESTAMP']

  /* Primary keys are indexed automatically; included below only to mirror the spec */
  Indexes {
    (property_id) [name: 'idx_properties_property_id']
  }
}

Table bookings {
  booking_id   uuid           [pk, note: 'Primary Key, UUID']
  property_id  uuid           [not null, note: 'FK -> properties.property_id']
  user_id      uuid           [not null, note: 'FK -> users.user_id (guest)']
  start_date   date           [not null]
  end_date     date           [not null]
  total_price  decimal        [not null]
  status       booking_status [not null]
  created_at   timestamp      [not null, default: `CURRENT_TIMESTAMP`]

  Indexes {
    (property_id) [name: 'idx_bookings_property_id']
    (booking_id)  [name: 'idx_bookings_booking_id']  /* Redundant with PK but included per spec */
  }
}

Table payments {
  payment_id     uuid            [pk, note: 'Primary Key, UUID']
  booking_id     uuid            [not null, note: 'FK -> bookings.booking_id']
  amount         decimal         [not null]
  payment_date   timestamp       [not null, default: `CURRENT_TIMESTAMP`]
  payment_method payment_method  [not null]

  Indexes {
    (booking_id) [name: 'idx_payments_booking_id']
  }
}

Table reviews {
  review_id   uuid      [pk, note: 'Primary Key, UUID']
  property_id uuid      [not null, note: 'FK -> properties.property_id']
  user_id     uuid      [not null, note: 'FK -> users.user_id (guest)']
  rating      int       [not null, note: 'CHECK (rating BETWEEN 1 AND 5)']
  comment     text      [not null]
  created_at  timestamp [not null, default: `CURRENT_TIMESTAMP`]
}

Table messages {
  message_id   uuid      [pk, note: 'Primary Key, UUID']
  sender_id    uuid      [not null, note: 'FK -> users.user_id (sender)']
  recipient_id uuid      [not null, note: 'FK -> users.user_id (recipient)']
  message_body text      [not null]
  sent_at      timestamp [not null, default: `CURRENT_TIMESTAMP`]
}

/* ===== Relationships ===== */
/* Users (hosts) -> Properties */
Ref: properties.host_id > users.user_id

/* Users (guests) -> Bookings */
Ref: bookings.user_id > users.user_id

/* Properties -> Bookings */
Ref: bookings.property_id > properties.property_id

/* Bookings -> Payments */
Ref: payments.booking_id > bookings.booking_id

/* Users & Properties -> Reviews */
Ref: reviews.user_id > users.user_id
Ref: reviews.property_id > properties.property_id

/* Messages (self-referencing to users) */
Ref: messages.sender_id > users.user_id
Ref: messages.recipient_id > users.user_id
