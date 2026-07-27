package com.hotel.model;

/**
 * User.java — Model (Java Bean)
 * Represents a user entry in the 'users' table.
 */
public class User {
    private int userId;
    private String fullName;
    private String email;
    private String password;

    public User() {} // No-arg constructor

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
