--insert queries

-- Add a new airline
INSERT INTO airlines (
    airline_name,
    IATA_code,
    ICAO_code,
    country,
    founded_year,
    contact_number
)
VALUES (
    'Pakistan International Airlines',
    'PK',
    'PIA',
    'Pakistan',
    1955,
    '03123456789'
);


-- Add a new airport
INSERT INTO airports (
    airport_name,
    IATA_code,
    ICAO_code,
    city,
    country,
    time_zone
)
VALUES (
    'Allama Iqbal International Airport',
    'LHE',
    'OPLA',
    'Lahore',
    'Pakistan',
    'Asia/Karachi'
),

(
    'Jinnah International Airport',
    'KHI',
    'OPKC',
    'Karachi',
    'Pakistan',
    'Asia/Karachi'
);


-- Add an aircraft
INSERT INTO aircraft (
    airline_id,
    model,
    manufacturer,
    registration_number,
    capacity,
    manufacturing_year,
    status
)
VALUES (
    1,
    'Boeing 777-300ER',
    'Boeing',
    'AP-BHV',
    393,
    2018,
    'Active'
);


-- Add an employee
INSERT INTO employees (
    airline_id,
    first_name,
    last_name,
    role,
    email,
    phone_number,
    hire_date,
    salary,
    status
)
VALUES (
    1,
    'Ahmed',
    'Khan',
    'Pilot',
    'ahmed.khan@pia.com',
    '03001234567',
    '2022-05-15',
    450000,
    'Active'
),

(
    1,
    'Sara',
    'Ahmed',
    'Cabin Crew',
    'sara.ahmed@pia.com',
    '03001112222',
    '2023-01-10',
    120000,
    'Active'
);


-- Register a passenger
INSERT INTO passengers (
    first_name,
    last_name,
    gender,
    date_of_birth,
    passport_number,
    nationality,
    email,
    phone_number,
    address
)
VALUES (
    'Fatima',
    'Ali',
    'Female',
    '2000-08-10',
    'PAK123456',
    'Pakistani',
    'fatima@example.com',
    '03111222333',
    'Lahore, Pakistan'
);


-- Schedule a flight
INSERT INTO flights (
    flight_number,
    airline_id,
    aircraft_id,
    departure_airport_id,
    arrival_airport_id,
    departure_datetime,
    arrival_datetime,
    base_fare,
    status
)
VALUES (
    'PK301',
    1,
    1,
    1,
    2,
    '2026-09-10 08:00:00',
    '2026-09-10 10:00:00',
    25000,
    'Scheduled'
);


-- Add a seat
INSERT INTO seats (
    aircraft_id,
    seat_number,
    seat_class,
    seat_position
)
VALUES (
    1,
    '12A',
    'Economy',
    'Window'
),

(
    1,
    '12B',
    'Economy',
    'Middle'
);


-- Create a booking
INSERT INTO bookings (
    passenger_id,
    flight_id,
    booking_status,
    total_amount
)
VALUES (
    1,
    1,
    'Confirmed',
    25000
);


-- Issue a ticket
INSERT INTO tickets (
    booking_id,
    seat_id,
    ticket_number,
    ticket_status
)
VALUES (
    1,
    1,
    'TKT100001',
    'Issued'
);


-- Record a payment
INSERT INTO payments (
    booking_id,
    payment_method,
    amount,
    transaction_id,
    payment_status
)
VALUES (
    1,
    'Card',
    25000,
    'TXN100001',
    'Completed'
);


-- Assign crew to a flight
INSERT INTO flight_crew (
    flight_id,
    employee_id,
    crew_role
)
VALUES (
    1,
    1,
    'Pilot'
),

(
    1,
    2,
    'Cabin Crew'
);


-- Add baggage
INSERT INTO baggage (
    ticket_id,
    number_of_bags,
    total_weight,
    baggage_type,
    extra_fee
)
VALUES (
    1,
    2,
    30,
    'Checked',
    5000
);





--select queries

-- View all available flights
SELECT * FROM available_flights;


-- View all bookings made by passengers
SELECT * FROM passenger_bookings;


-- View all crew assignments
SELECT * FROM flight_crew_details;


-- View payment summary
SELECT * FROM payment_summary;


-- Find a passenger using passport number
SELECT *
FROM passengers
WHERE passport_number = 'PAK123456';


-- Find all flights operated by an airline
SELECT flight_number, departure_datetime, arrival_datetime
FROM flights
WHERE airline_id = 1;


-- Find all bookings for a passenger
SELECT *
FROM bookings
WHERE passenger_id = 1;


-- Find all tickets for a booking
SELECT *
FROM tickets
WHERE booking_id = 1;


-- Find baggage information for a ticket
SELECT *
FROM baggage
WHERE ticket_id = 1;


-- Find all employees of an airline
SELECT first_name, last_name, role
FROM employees
WHERE airline_id = 1;


-- Find all flights departing from a specific airport
SELECT flight_number, departure_datetime
FROM flights
WHERE departure_airport_id = 1;


-- Find all seats in an aircraft
SELECT seat_number, seat_class
FROM seats
WHERE aircraft_id = 1;

-- View ticket and assigned seat details
SELECT
    t.ticket_number,
    s.seat_number,
    s.seat_class,
    s.seat_position
FROM tickets t
JOIN seats s
ON t.seat_id = s.seat_id;

-- Show passenger name with flight number and ticket number
SELECT
    p.first_name || ' ' || p.last_name AS passenger_name,
    f.flight_number,
    t.ticket_number
FROM passengers p
JOIN bookings b
    ON p.passenger_id = b.passenger_id
JOIN flights f
    ON b.flight_id = f.flight_id
JOIN tickets t
    ON b.booking_id = t.booking_id;




--update queries

-- Update a passenger's email
UPDATE passengers
SET email = 'fatima.new@example.com'
WHERE passenger_id = 1;


-- Update flight status
UPDATE flights
SET status = 'Boarding'
WHERE flight_id = 1;


-- Change booking status
UPDATE bookings
SET booking_status = 'Pending'
WHERE booking_id = 1;


-- Change passenger seat
UPDATE tickets
SET seat_id = 2
WHERE ticket_id = 1;


-- Update payment status
UPDATE payments
SET payment_status = 'Refunded'
WHERE payment_id = 1;


-- Update employee status
UPDATE employees
SET status = 'On Leave'
WHERE employee_id = 1;



--delete queries

-- Delete baggage first
DELETE FROM baggage
WHERE baggage_id = 1;

-- Delete payment
DELETE FROM payments
WHERE payment_id = 1;

-- Delete ticket
DELETE FROM tickets
WHERE ticket_id = 1;

-- Delete booking
DELETE FROM bookings
WHERE booking_id = 1;

-- Delete passenger
DELETE FROM passengers
WHERE passenger_id = 1;