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
    floor_id BIGINT REFERENCES floors(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seats (
    id BIGSERIAL PRIMARY KEY,
    seat_number VARCHAR(255) NOT NULL,
    room_id BIGINT REFERENCES office_rooms(id),
    is_occupied BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    seats_id BIGINT REFERENCES seats(id) ON DELETE SET NULL,
    department INTEGER DEFAULT 0, -- Set a valid default value
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

-- Insert employees
INSERT INTO employees (name, seats_id, department, created_at)
VALUES
    ('Alice Johnson', 1, 101, '2025-01-01 09:00:00'),
    ('Bob Smith', 2, 102, '2025-01-02 10:30:00'),
    ('Charlie Brown', 3, 103, '2025-01-03 14:15:00'),
    ('Diana Prince', 4, 104, '2025-01-04 08:45:00'),
    ('Edward Norton', 5, 105, '2025-01-05 16:00:00'),
    ('Fiona Gallagher', NULL, 106, '2025-01-06 12:00:00'),
    ('George Michael', NULL, 107, DEFAULT),
    ('Hannah Baker', 2, 108, DEFAULT),
    ('Ian Somerhalder', 3, 109, '2025-01-07 09:00:00'),
    ('Jessica Jones', NULL, 110, '2025-01-08 11:30:00');