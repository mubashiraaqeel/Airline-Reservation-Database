# Airline Reservation Management System

## By Mubashira Aqeel

## Project Overview

The Airline Reservation Management System is a relational database designed to manage the core operations of an airline reservation platform. The database stores information about airlines, airports, aircraft, employees, passengers, flights, bookings, tickets, payments, crew assignments, baggage, and seating.

The primary goal of this project is to provide a well-structured database that maintains data integrity while supporting common airline operations such as scheduling flights, booking tickets, assigning crew members, processing payments, and managing passenger baggage.

This project was developed using SQLite and demonstrates the use of relational database design principles, including primary keys, foreign keys, constraints, indexes, and views.

---

# Video Overview

Video demonstration of the Airline Reservation Management System:

**Video Link:** https://youtu.be/JMrZ9GDIh6Y

---

# Entity Relationship Diagram

The following ERD illustrates the structure of the Airline Reservation Management System database.

![alt text](erd.png)

---

# Scope

This database is designed to support the following operations:

- Store airline information.
- Store airport information.
- Manage aircraft owned by airlines.
- Maintain employee records.
- Register passengers.
- Schedule flights between airports.
- Record flight bookings.
- Issue tickets.
- Process passenger payments.
- Assign crew members to flights.
- Store baggage information.
- Retrieve useful information through SQL views.

The database focuses on reservation management only. It does not include features such as online authentication, employee login systems, flight tracking, or aircraft maintenance history.

---

# Entities

## Airlines

Stores information about airline companies.

Important attributes include:

- airline_id
- airline_name
- IATA_code
- ICAO_code
- country
- founded_year
- contact_number

Each airline can own multiple aircraft, employ multiple employees, and operate many flights.

---

## Airports

Stores airport information.

Important attributes include:

- airport_id
- airport_name
- IATA_code
- ICAO_code
- city
- country
- time_zone

Each airport may serve as both the departure and arrival airport for many flights.

---

## Aircraft

Stores aircraft owned by airlines.

Important attributes include:

- aircraft_id
- airline_id
- model
- manufacturer
- registration_number
- capacity
- manufacturing_year
- status

Each aircraft belongs to exactly one airline and can operate many flights over time.

---

## Employees

Stores airline employee information.

Important attributes include:

- employee_id
- airline_id
- first_name
- last_name
- role
- email
- phone_number
- hire_date
- salary
- status

Employees can later be assigned to flights through the Flight_Crew table.

---

## Passengers

Stores passenger information.

Important attributes include:

- passenger_id
- first_name
- last_name
- gender
- date_of_birth
- passport_number
- nationality
- email
- phone_number
- address

Each passenger may create multiple bookings.

---

## Flights

Stores scheduled flights.

Important attributes include:

- flight_id
- flight_number
- airline_id
- aircraft_id
- departure_airport_id
- arrival_airport_id
- departure_datetime
- arrival_datetime
- base_fare
- status

Constraints ensure that:

- departure and arrival airports cannot be the same.
- arrival time must be after departure time.

---

## Seats

Stores aircraft seating information.

Important attributes include:

- seat_id
- aircraft_id
- seat_number
- seat_class
- seat_position

A UNIQUE constraint prevents duplicate seat numbers within the same aircraft.

---

## Bookings

Stores passenger reservations.

Important attributes include:

- booking_id
- passenger_id
- flight_id
- booking_date
- booking_status
- total_amount

Each booking belongs to one passenger and one flight.

---

## Tickets

Stores issued tickets.

Important attributes include:

- ticket_id
- booking_id
- seat_id
- ticket_number
- issue_date
- ticket_status

Each booking generates one ticket.

---

## Payments

Stores payment information.

Important attributes include:

- payment_id
- booking_id
- payment_date
- payment_method
- amount
- transaction_id
- payment_status

Each payment is associated with a booking.

---

## Flight_Crew

Represents the many-to-many relationship between flights and employees.

Important attributes include:

- flight_id
- employee_id
- crew_role

A composite primary key ensures that an employee cannot be assigned to the same flight more than once.

---

## Baggage

Stores baggage information associated with tickets.

Important attributes include:

- baggage_id
- ticket_id
- number_of_bags
- total_weight
- baggage_type
- extra_fee

Each baggage record belongs to a ticket.

---

# Relationships

The database includes several one-to-many relationships:

- One airline → many aircraft
- One airline → many employees
- One airline → many flights
- One airport → many departures
- One airport → many arrivals
- One passenger → many bookings
- One flight → many bookings
- One booking → one ticket
- One booking → one payment
- One aircraft → many seats
- One ticket → many baggage records

The Flight_Crew table creates a many-to-many relationship between flights and employees.

---

# Design Choices

Several design decisions were made to improve data integrity and reduce redundancy.

Primary keys uniquely identify every record.

Foreign keys maintain relationships between tables and prevent invalid references.

CHECK constraints validate values such as:

- positive fares
- positive salaries
- valid booking status
- valid payment status
- valid flight status
- valid baggage type
- valid employee roles
- valid seat classes

UNIQUE constraints prevent duplicate values for:

- flight numbers
- passport numbers
- registration numbers
- transaction IDs
- ticket numbers
- email addresses
- seat numbers within an aircraft

The Flight_Crew table was implemented instead of storing crew members directly in the Flights table because multiple employees may serve on a single flight, and employees participate in many flights.

---

# Views

The database includes four views to simplify common queries.

### available_flights

Displays scheduled flights together with airline and airport information.

### passenger_bookings

Displays booking information along with passenger names and flight numbers.

### flight_crew_details

Displays crew members assigned to each flight.

### payment_summary

Displays passenger payment information together with booking and flight details.

These views simplify reporting and reduce the complexity of frequently used SQL queries.

---

# Indexes

Indexes were created on foreign key columns that are frequently used in joins and search operations.

These include indexes on:

- aircraft.airline_id
- bookings.passenger_id
- bookings.flight_id
- flights.airline_id
- flights.departure_airport_id
- flights.arrival_airport_id

These indexes improve query performance while avoiding unnecessary duplication of indexes automatically created for PRIMARY KEY and UNIQUE columns.

---

# Optimizations

The database was optimized by:

- Normalizing data into separate tables.
- Eliminating redundant data.
- Using foreign keys to enforce referential integrity.
- Using CHECK constraints for validation.
- Creating indexes on frequently searched columns.
- Creating views for common reporting queries.

These optimizations improve maintainability, consistency, and query performance.

---

# Limitations

This project intentionally excludes several real-world airline features.

Examples include:

- User authentication
- Employee login accounts
- Flight delay history
- Boarding passes
- Flight cancellation workflows
- Multiple payment transactions per booking
- Loyalty and reward programs
- Aircraft maintenance records
- Real-time seat availability
- International visa requirements

These features could be added in future versions of the database.

---

# Conclusion

This database demonstrates the use of relational database principles to model an airline reservation system. It combines normalized tables, foreign key relationships, constraints, indexes, and views to create a structured and efficient database capable of supporting common airline reservation operations while maintaining data consistency and integrity.