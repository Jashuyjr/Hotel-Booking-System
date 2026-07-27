package com.hotel.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // ── Database Configuration Constants ─────────────────────────────────────
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/hotel_booking_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER     = "root";       // Change to your MySQL username
    private static final String DB_PASSWORD = "4321"; // Change to your MySQL password
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // Static block: loads the JDBC driver once when the class is first used
    static {
        try {
            Class.forName(DRIVER_CLASS);
            System.out.println("[DBUtil] MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBUtil] ERROR: MySQL JDBC Driver not found!");
            throw new ExceptionInInitializerError(e);
        }
    }

    /**
     * Returns a new JDBC Connection to the hotel_booking_db database.
     * ALWAYS close the connection in a finally block or use try-with-resources.
     *
     * @return java.sql.Connection
     * @throws SQLException if connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely closes a Connection (null-safe).
     * Call this in the finally block of any DAO method.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBUtil] Warning: Failed to close connection - " + e.getMessage());
            }
        }
    }

    // Private constructor: prevents instantiation of this utility class
    private DBUtil() {}
}
