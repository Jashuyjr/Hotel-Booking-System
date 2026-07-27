package com.hotel.dao;

import com.hotel.model.User;
import com.hotel.util.DBUtil;
import java.sql.*;

public class UserDAO {
    // SQL to insert a new guest
    private static final String SQL_INSERT = "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)";

    public boolean registerUser(User user) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Plain text for demo; use hashing -> production
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] Error: " + e.getMessage());
            return false;
        }
    }
}
