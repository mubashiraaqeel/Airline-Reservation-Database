PRAGMA foreign_keys = ON;

-- Tables
CREATE TABLE airlines(
    airline_id integer PRIMARY KEY AUTOINCREMENT,
    airline_name text NOT NULL UNIQUE,
    IATA_code text NOT NULL UNIQUE,
    ICAO_code text NOT NULL UNIQUE,
    country text NOT NULL,
    founded_year integer CHECK(founded_year BETWEEN 1900 AND 2100),
    contact_number text UNIQUE CHECK(length(contact_number) = 11)
    );

CREATE TABLE airports(
    airport_id integer PRIMARY KEY AUTOINCREMENT,
    airport_name text NOT NULL,
    IATA_code text NOT NULL UNIQUE,
    ICAO_code text NOT NULL UNIQUE,
    city text NOT NULL,
    country text NOT NULL,
    time_zone text NOT NULL
    );

CREATE TABLE aircraft(
    aircraft_id integer PRIMARY KEY AUTOINCREMENT,
    airline_id integer NOT NULL,
    model text NOT NULL,
    manufacturer text NOT NULL,
    registration_number text NOT NULL UNIQUE,
    capacity integer NOT NULL CHECK(capacity > 0),
    manufacturing_year integer NOT NULL CHECK(manufacturing_year >= 1950),
    status text NOT NULL CHECK(status IN ('Active','Maintenance','Retired')),

    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)

    );

CREATE TABLE employees(
    employee_id integer PRIMARY KEY AUTOINCREMENT,
    airline_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    role text NOT NULL CHECK (role IN ('Pilot','Co-Pilot','Cabin Crew','Ground Staff','Engineer','Manager')),
    email text NOT NULL UNIQUE,
    phone_number text UNIQUE CHECK(length(phone_number) = 11),
    hire_date date NOT NULL,
    salary real NOT NULL CHECK(salary > 0),
    status text NOT NULL DEFAULT 'Active' CHECK (status IN ('Active','Inactive','On Leave')),

    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id)

    );

CREATE TABLE passengers(
    passenger_id integer PRIMARY KEY AUTOINCREMENT,
    first_name text NOT NULL,
    last_name text NOT NULL,
    gender text NOT NULL CHECK (gender IN ('Male','Female','Other')),
    date_of_birth date NOT NULL,
    passport_number text UNIQUE NOT NULL,
    nationality text NOT NULL,
    email text UNIQUE,
    phone_number text UNIQUE CHECK(length(phone_number) = 11),
    address text NOT NULL
    );

CREATE TABLE flights(
    flight_id integer PRIMARY KEY AUTOINCREMENT,
    flight_number text UNIQUE NOT NULL,
    airline_id integer NOT NULL,
    aircraft_id integer NOT NULL,
    departure_airport_id integer NOT NULL,
    arrival_airport_id integer NOT NULL,
    departure_datetime datetime NOT NULL,
    arrival_datetime datetime NOT NULL,
    base_fare real NOT NULL CHECK (base_fare > 0),
    status text NOT NULL DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'Delayed', 'Boarding', 'Departed', 'Arrived', 'Cancelled')),

    CHECK (departure_airport_id <> arrival_airport_id),
    CHECK (arrival_datetime > departure_datetime),

    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id)

    );

CREATE TABLE seats(
    seat_id integer PRIMARY KEY AUTOINCREMENT,
    aircraft_id integer NOT NULL,
    seat_number text NOT NULL,
    seat_class text NOT NULL CHECK(seat_class IN ('Economy','Business','First')),
    seat_position text NOT NULL CHECK(seat_position IN ('Window','Middle','Aisle')),

    UNIQUE (aircraft_id, seat_number),

    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)

    );

CREATE TABLE bookings(
    booking_id integer PRIMARY KEY AUTOINCREMENT,
    passenger_id integer NOT NULL,
    flight_id integer NOT NULL,
    booking_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_status text NOT NULL DEFAULT'Confirmed' CHECK(booking_status IN ('Pending','Confirmed')),
    total_amount real NOT NULL CHECK(total_amount >= 0),

    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)

    );

CREATE TABLE tickets(
    ticket_id integer PRIMARY KEY AUTOINCREMENT,
    booking_id integer NOT NULL,
    seat_id integer NOT NULL,
    ticket_number text NOT NULL UNIQUE,
    issue_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ticket_status text NOT NULL DEFAULT'Issued' CHECK (ticket_status IN ('Issued','Cancelled','Used')),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)

    );

CREATE TABLE payments(
    payment_id integer PRIMARY KEY AUTOINCREMENT,
    booking_id integer NOT NULL,
    payment_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method text NOT NULL CHECK(payment_method IN ('Cash','Card','Online')),
    amount real NOT NULL CHECK(amount > 0),
    transaction_id text NOT NULL UNIQUE,
    payment_status text NOT NULL DEFAULT'Completed' CHECK (payment_status IN ('Pending','Completed','Failed','Refunded')),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)

    );

CREATE TABLE flight_crew(
    flight_id integer NOT NULL,
    employee_id integer NOT NULL,
    crew_role text NOT NULL CHECK (crew_role IN ('Pilot','Co-Pilot','Cabin Crew')),
    PRIMARY KEY(flight_id, employee_id),

    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)

    );

CREATE TABLE baggage(
    baggage_id integer PRIMARY KEY AUTOINCREMENT,
    ticket_id integer NOT NULL,
    number_of_bags integer NOT NULL CHECK(number_of_bags >= 0),
    total_weight real NOT NULL CHECK(total_weight >= 0),
    baggage_type text NOT NULL CHECK(baggage_type IN ('Checked','Carry-on')),
    extra_fee real NOT NULL DEFAULT 0 CHECK (extra_fee >= 0),

    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)

    );

--indexes

-- Aircraft by airline
CREATE INDEX idx_aircraft_airline
ON aircraft(airline_id);

-- Bookings by passenger
CREATE INDEX idx_booking_passenger
ON bookings(passenger_id);

-- Bookings by flight
CREATE INDEX idx_booking_flight
ON bookings(flight_id);

-- Flights by airline
CREATE INDEX idx_flight_airline
ON flights(airline_id);

-- Flights by departure airport
CREATE INDEX idx_departure_airport
ON flights(departure_airport_id);

-- Flights by arrival airport
CREATE INDEX idx_arrival_airport
ON flights(arrival_airport_id);

--views

CREATE VIEW available_flights AS
SELECT
    f.flight_id,
    f.flight_name,
    a.airline_name,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport,
    f.departure_datetime,
    f.arrival_datetime,
    f.base_fare,
    f.status
FROM flights f
JOIN airlines a
    ON f.airline_id = a.airline_id
JOIN airports dep
    ON f.departure_airport_id = dep.airport_id
JOIN airports arr
    ON f.arrival_airport_id = arr.airport_id;



-- Shows booking details for each passenger

CREATE VIEW passenger_bookings AS
SELECT
    b.booking_id,
    p.passenger_id,
    p.first_name || ' ' || p.last_name AS passenger_name,
    f.flight_number,
    b.booking_date,
    b.booking_status,
    b.total_amount
FROM bookings b
JOIN passengers p
    ON b.passenger_id = p.passenger_id
JOIN flights f
    ON b.flight_id = f.flight_id;



-- Shows crew members assigned to each flight

CREATE VIEW flight_crew_details AS
SELECT
    f.flight_number,
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.role AS employee_role,
    fc.crew_role
FROM flight_crew fc
JOIN flights f
    ON fc.flight_id = f.flight_id
JOIN employees e
    ON fc.employee_id = e.employee_id;



-- Shows payment details for each booking

CREATE VIEW payment_summary AS
SELECT
    p.payment_id,
    ps.first_name || ' ' || ps.last_name AS passenger_name,
    f.flight_number,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.payment_date
FROM payments p
JOIN bookings b
    ON p.booking_id = b.booking_id
JOIN passengers ps
    ON b.passenger_id = ps.passenger_id
JOIN flights f
    ON b.flight_id = f.flight_id;