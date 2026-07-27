-- ============================================================
-- Hotel Booking System - Database Schema
-- Database: MySQL 8.x
-- Topic: JDBC Connectivity & SQL Queries (Syllabus Topic)
-- ============================================================

-- Create and use the database
CREATE DATABASE IF NOT EXISTS hotel_booking_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hotel_booking_db;

-- ============================================================
-- TABLE: users
-- Stores guest/user information
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    password    VARCHAR(255) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: rooms
-- Stores hotel room inventory
-- ============================================================
CREATE TABLE IF NOT EXISTS rooms (
    room_id         INT AUTO_INCREMENT PRIMARY KEY,
    room_number     VARCHAR(10) NOT NULL UNIQUE,
    room_type       ENUM('Standard', 'Deluxe', 'Suite', 'Executive') NOT NULL,
    capacity        INT NOT NULL DEFAULT 2,
    price_per_night DECIMAL(10, 2) NOT NULL,
    description     TEXT,
    amenities       VARCHAR(500),
    is_available    BOOLEAN DEFAULT TRUE,
    image_url       VARCHAR(300)
);

-- ============================================================
-- TABLE: bookings
-- Stores booking/reservation records
-- ============================================================
CREATE TABLE IF NOT EXISTS bookings (
    booking_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    room_id         INT NOT NULL,
    check_in_date   DATE NOT NULL,
    check_out_date  DATE NOT NULL,
    total_nights    INT NOT NULL,
    total_price     DECIMAL(10, 2) NOT NULL,
    guest_name      VARCHAR(100) NOT NULL,
    guest_email     VARCHAR(150) NOT NULL,
    guest_phone     VARCHAR(20),
    special_requests TEXT,
    booking_status  ENUM('Confirmed', 'Pending', 'Cancelled') DEFAULT 'Confirmed',
    booked_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA: Sample Rooms
-- ============================================================
INSERT INTO rooms (room_number, room_type, capacity, price_per_night, description, amenities, is_available, image_url) VALUES
('101', 'Standard', 2, 4999.00, 'A cozy standard room with a city view and all modern amenities for a comfortable stay.', 'Free WiFi, TV, Air Conditioning, Hot Water, Room Service', TRUE, 'standard.jpg'),
('102', 'Standard', 2, 4999.00, 'Bright and airy standard room on the first floor, perfect for short business trips.', 'Free WiFi, TV, Air Conditioning, Hot Water, Room Service', TRUE, 'standard.jpg'),
('201', 'Deluxe', 2, 8499.00, 'Spacious deluxe room with a king-size bed, balcony overlooking the garden, and premium furnishings.', 'Free WiFi, Smart TV, Air Conditioning, Mini Bar, Bathtub, Balcony, Room Service', TRUE, 'deluxe.jpg'),
('202', 'Deluxe', 3, 9299.00, 'A large deluxe room ideal for families, featuring extra bedding and a panoramic view.', 'Free WiFi, Smart TV, Air Conditioning, Mini Bar, Bathtub, Balcony, Room Service', TRUE, 'deluxe.jpg'),
('301', 'Suite', 4, 18999.00, 'Luxurious suite with a separate living area, kitchenette, and breathtaking skyline views.', 'Free WiFi, Smart TV, Air Conditioning, Full Kitchen, Jacuzzi, Private Balcony, Butler Service, Room Service', TRUE, 'suite.jpg'),
('401', 'Executive', 2, 24999.00, 'Our premium executive room designed for high-end travelers, with bespoke decor and top-floor exclusivity.', 'Free WiFi, 4K TV, Climate Control, Full Bar, Sauna, Private Terrace, Concierge, Valet Parking', TRUE, 'executive.jpg');

-- ============================================================
-- SEED DATA: Sample User (password: 'password123' - in real app use hashed)
-- ============================================================
INSERT INTO users (full_name, email, phone, password) VALUES
('Demo Guest', 'guest@hotel.com', '9876543210', 'password123');

-- ============================================================
-- Useful Queries (for DAO reference)
-- ============================================================

-- Get all available rooms:
-- SELECT * FROM rooms WHERE is_available = TRUE;

-- Get rooms by type:
-- SELECT * FROM rooms WHERE room_type = ? AND is_available = TRUE;

-- Insert a new booking:
-- INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, total_nights, total_price, guest_name, guest_email, guest_phone, special_requests)
-- VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

-- Get booking confirmation by ID:
-- SELECT b.*, r.room_number, r.room_type, r.price_per_night FROM bookings b JOIN rooms r ON b.room_id = r.room_id WHERE b.booking_id = ?;
