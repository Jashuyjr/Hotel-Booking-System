package com.hotel.dao;

import com.hotel.model.Room;
import com.hotel.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RoomDAO.java - Data Access Object
 * ============================================================
 * SYLLABUS TOPIC: JDBC — SQL Queries & DAO Pattern
 *
 * The DAO (Data Access Object) pattern abstracts all database
 * operations for the Room entity. Servlets use this class to
 * interact with the DB without writing SQL themselves.
 *
 * Demonstrates:
 *  - PreparedStatement (prevents SQL Injection)
 *  - ResultSet traversal
 *  - try-with-resources for automatic resource cleanup
 * ============================================================
 */
public class RoomDAO {

    // ── SQL Query Constants ───────────────────────────────────────────────────
    private static final String SQL_GET_ALL_AVAILABLE =
        "SELECT * FROM rooms WHERE is_available = TRUE ORDER BY price_per_night ASC";

    private static final String SQL_GET_BY_TYPE =
        "SELECT * FROM rooms WHERE room_type = ? AND is_available = TRUE ORDER BY price_per_night ASC";

    private static final String SQL_GET_BY_ID =
        "SELECT * FROM rooms WHERE room_id = ?";

    private static final String SQL_UPDATE_AVAILABILITY =
        "UPDATE rooms SET is_available = ? WHERE room_id = ?";

    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Fetches all rooms that are currently available.
     * Used by RoomSearchServlet to populate the index.jsp view.
     *
     * @return List of available Room objects
     */
    public List<Room> getAllAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        // try-with-resources: auto-closes Connection, Statement, ResultSet
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_AVAILABLE);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                rooms.add(mapRow(rs)); // Map each DB row to a Room object
            }

        } catch (SQLException e) {
            System.err.println("[RoomDAO] Error fetching available rooms: " + e.getMessage());
        }
        return rooms;
    }

    /**
     * Fetches available rooms filtered by type (Standard, Deluxe, Suite, Executive).
     * Demonstrates parameterized query using PreparedStatement to prevent SQL Injection.
     *
     * @param roomType the type filter string
     * @return filtered List of Room objects
     */
    public List<Room> getRoomsByType(String roomType) {
        List<Room> rooms = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_TYPE)) {

            ps.setString(1, roomType); // Safely bind parameter
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[RoomDAO] Error fetching rooms by type: " + e.getMessage());
        }
        return rooms;
    }

    /**
     * Fetches a single Room by its primary key (room_id).
     * Used by BookingServlet to validate and price the booking.
     *
     * @param roomId the room's primary key
     * @return Room object, or null if not found
     */
    public Room getRoomById(int roomId) {
        Room room = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    room = mapRow(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[RoomDAO] Error fetching room by ID: " + e.getMessage());
        }
        return room;
    }

    /**
     * Updates the availability status of a room.
     * Called after a successful booking to mark room as unavailable.
     *
     * @param roomId    the room to update
     * @param available true = available, false = booked
     * @return true if update was successful
     */
    public boolean updateAvailability(int roomId, boolean available) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_AVAILABILITY)) {

            ps.setBoolean(1, available);
            ps.setInt(2, roomId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[RoomDAO] Error updating room availability: " + e.getMessage());
            return false;
        }
    }

    // ── Private Helper: Maps a ResultSet row to a Room object ─────────────────
    private Room mapRow(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setCapacity(rs.getInt("capacity"));
        room.setPricePerNight(rs.getDouble("price_per_night"));
        room.setDescription(rs.getString("description"));
        room.setAmenities(rs.getString("amenities"));
        room.setAvailable(rs.getBoolean("is_available"));
        room.setImageUrl(rs.getString("image_url"));
        return room;
    }
}
