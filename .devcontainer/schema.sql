-- Drop database if exists and recreate it
DROP DATABASE IF EXISTS office_management;
CREATE DATABASE office_management;
\c office_management;

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS office_rooms;
DROP TABLE IF EXISTS floors;

-- Create tables
CREATE TABLE floors (
    id BIGSERIAL PRIMARY KEY,
    floor_number INTEGER NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE office_rooms (
    id BIGSERIAL PRIMARY KEY,
    room_number VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    floor_id BIGINT REFERENCES floors(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE employees (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    occupation VARCHAR (50), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seats (
    id BIGSERIAL PRIMARY KEY,
    seat_number VARCHAR(255) NOT NULL,
    room_id BIGINT REFERENCES office_rooms(id) ON DELETE CASCADE,
    employee_id BIGINT REFERENCES employees(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Insert floors
INSERT INTO floors (floor_number, name) VALUES
(1, 'First Floor'),
(2, 'Second Floor'),
(3, 'Third Floor'),
(4, 'Fourth Floor'),
(5, 'Fifth Floor'),
(6, 'Sixth Floor'),
(7, 'Seventh Floor'),
(8, 'Eighth Floor'),
(9, 'Ninth Floor');

-- Insert rooms for each floor
DO $$
DECLARE
    floor_record RECORD;
BEGIN
    FOR floor_record IN SELECT id, floor_number FROM floors ORDER BY floor_number
    LOOP
        FOR room_num IN 1..20
        LOOP
            INSERT INTO office_rooms (room_number, name, floor_id)
            VALUES (
                CONCAT(floor_record.floor_number, LPAD(room_num::text, 2, '0')),
                CONCAT('Room ', floor_record.floor_number, LPAD(room_num::text, 2, '0')),
                floor_record.id
            );
        END LOOP;
    END LOOP;
END $$;

-- Insert seats for each room
DO $$
DECLARE
    room_record RECORD;
BEGIN
    FOR room_record IN SELECT id, room_number FROM office_rooms
    LOOP
        FOR seat_num IN 1..4
        LOOP
            INSERT INTO seats (seat_number, room_id)
            VALUES (
                CONCAT(room_record.room_number, '-', LPAD(seat_num::text, 2, '0')),
                room_record.id
            );
        END LOOP;
    END LOOP;
END $$;

-- Insert employees with different occupations
INSERT INTO employees (name, occupation, created_at)
VALUES
    ('Alice Johnson', 'Engineer', '2025-01-01 09:00:00'),
    ('Bob Smith', 'Manager', '2025-01-02 10:30:00'),
    ('Charlie Brown', 'Designer', '2025-01-03 14:15:00'),
    ('Diana Prince', 'Architect', '2025-01-04 08:45:00'),
    ('Edward Norton', 'Technician', '2025-01-05 16:00:00'),
    ('Fiona Gallagher', 'HR Specialist', '2025-01-06 12:00:00'),
    ('George Michael', 'Intern', DEFAULT),
    ('Hannah Baker', 'Consultant', DEFAULT),
    ('Ian Somerhalder', 'Analyst', '2025-01-07 09:00:00'),
    ('Jessica Jones', 'Administrator', '2025-01-08 11:30:00');