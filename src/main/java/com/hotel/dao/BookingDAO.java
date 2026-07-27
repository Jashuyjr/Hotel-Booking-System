package com.hotel.dao;

import com.hotel.model.Booking;
import com.hotel.util.DBUtil;

import java.sql.*;

/**
 * BookingDAO.java - Data Access Object
 * ============================================================
 * SYLLABUS TOPIC: JDBC — INSERT, SELECT with JOIN, Transactions
 *
 * Handles all CRUD operations for the Booking entity.
 * Key concepts demonstrated:
 *  - Statement.RETURN_GENERATED_KEYS: retrieves auto-generated PK
 *  - SQL JOIN: fetches booking + room info in one query
 *  - Transaction management: conn.setAutoCommit(false)
 * ============================================================
 */
public class BookingDAO {

    // ── SQL Query Constants ───────────────────────────────────────────────────
    private static final String SQL_INSERT_BOOKING =
        "INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, " +
        "total_nights, total_price, guest_name, guest_email, guest_phone, special_requests) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_GET_BY_ID =
        "SELECT b.*, r.room_number, r.room_type, r.price_per_night " +
        "FROM bookings b " +
        "JOIN rooms r ON b.room_id = r.room_id " +
        "WHERE b.booking_id = ?";

    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Inserts a new Booking record into the database.
     *
     * Uses a TRANSACTION to ensure both:
     *  1. The booking row is inserted
     *  2. The room's availability is marked false
     * are committed atomically (all-or-nothing).
     *
     * @param booking the Booking object populated from the form
     * @return the auto-generated booking_id, or -1 on failure
     */
    public int createBooking(Booking booking) {
        int generatedId = -1;
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // ── Begin Transaction ─────────────────

            // Step 1: Insert the booking record
            try (PreparedStatement ps = conn.prepareStatement(SQL_INSERT_BOOKING,
                                            Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, booking.getUserId());
                ps.setInt(2, booking.getRoomId());
                ps.setDate(3, booking.getCheckInDate());
                ps.setDate(4, booking.getCheckOutDate());
                ps.setInt(5, booking.getTotalNights());
                ps.setDouble(6, booking.getTotalPrice());
                ps.setString(7, booking.getGuestName());
                ps.setString(8, booking.getGuestEmail());
                ps.setString(9, booking.getGuestPhone());
                ps.setString(10, booking.getSpecialRequests());

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    // Retrieve the auto-generated booking_id
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            generatedId = generatedKeys.getInt(1);
                        }
                    }
                }
            }

            // Step 2: Mark room as unavailable (within same transaction)
            String updateRoom = "UPDATE rooms SET is_available = FALSE WHERE room_id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(updateRoom)) {
                ps2.setInt(1, booking.getRoomId());
                ps2.executeUpdate();
            }

            conn.commit(); // ── Commit Transaction ────────────────────────────
            System.out.println("[BookingDAO] Booking created successfully. ID: " + generatedId);

        } catch (SQLException e) {
            System.err.println("[BookingDAO] Transaction failed: " + e.getMessage());
            // ── Rollback on failure ────────────────────────────────────────────
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            }
            generatedId = -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { /* ignore */ }
            }
            DBUtil.closeConnection(conn);
        }

        return generatedId;
    }

    /**
     * Retrieves a Booking by its ID, joining with the rooms table.
     * Used by confirmation.jsp to display booking details.
     *
     * Demonstrates: SQL JOIN query via JDBC
     *
     * @param bookingId the booking's primary key
     * @return Booking object with joined room data, or null
     */
    public Booking getBookingById(int bookingId) {
        Booking booking = null;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new Booking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setRoomId(rs.getInt("room_id"));
                    booking.setCheckInDate(rs.getDate("check_in_date"));
                    booking.setCheckOutDate(rs.getDate("check_out_date"));
                    booking.setTotalNights(rs.getInt("total_nights"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setGuestName(rs.getString("guest_name"));
                    booking.setGuestEmail(rs.getString("guest_email"));
                    booking.setGuestPhone(rs.getString("guest_phone"));
                    booking.setSpecialRequests(rs.getString("special_requests"));
                    booking.setBookingStatus(rs.getString("booking_status"));
                    booking.setBookedAt(rs.getTimestamp("booked_at"));
                    // Joined fields from rooms table
                    booking.setRoomNumber(rs.getString("room_number"));
                    booking.setRoomType(rs.getString("room_type"));
                    booking.setPricePerNight(rs.getDouble("price_per_night"));
                }
            }

        } catch (SQLException e) {
            System.err.println("[BookingDAO] Error fetching booking: " + e.getMessage());
        }

        return booking;
    }
}
