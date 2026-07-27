package com.hotel.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Booking.java - Model (Java Bean)
 * ============================================================
 * SYLLABUS TOPIC: MVC Architecture — MODEL layer
 *
 * Represents a hotel booking/reservation. Maps to the
 * 'bookings' table. Note the use of java.sql.Date for
 * compatibility with JDBC PreparedStatement.
 * ============================================================
 */
public class Booking {

    private int       bookingId;
    private int       userId;
    private int       roomId;
    private Date      checkInDate;
    private Date      checkOutDate;
    private int       totalNights;
    private double    totalPrice;
    private String    guestName;
    private String    guestEmail;
    private String    guestPhone;
    private String    specialRequests;
    private String    bookingStatus;
    private Timestamp bookedAt;

    // ── Joined fields (from Room table, not stored in Booking) ───────────────
    private String    roomNumber;
    private String    roomType;
    private double    pricePerNight;

    // ── No-Arg Constructor ────────────────────────────────────────────────────
    public Booking() {}

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int getBookingId()                         { return bookingId; }
    public void setBookingId(int bookingId)           { this.bookingId = bookingId; }

    public int getUserId()                            { return userId; }
    public void setUserId(int userId)                 { this.userId = userId; }

    public int getRoomId()                            { return roomId; }
    public void setRoomId(int roomId)                 { this.roomId = roomId; }

    public Date getCheckInDate()                      { return checkInDate; }
    public void setCheckInDate(Date checkInDate)      { this.checkInDate = checkInDate; }

    public Date getCheckOutDate()                     { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate)    { this.checkOutDate = checkOutDate; }

    public int getTotalNights()                       { return totalNights; }
    public void setTotalNights(int totalNights)       { this.totalNights = totalNights; }

    public double getTotalPrice()                     { return totalPrice; }
    public void setTotalPrice(double totalPrice)      { this.totalPrice = totalPrice; }

    public String getGuestName()                      { return guestName; }
    public void setGuestName(String guestName)        { this.guestName = guestName; }

    public String getGuestEmail()                     { return guestEmail; }
    public void setGuestEmail(String guestEmail)      { this.guestEmail = guestEmail; }

    public String getGuestPhone()                     { return guestPhone; }
    public void setGuestPhone(String guestPhone)      { this.guestPhone = guestPhone; }

    public String getSpecialRequests()                        { return specialRequests; }
    public void setSpecialRequests(String specialRequests)    { this.specialRequests = specialRequests; }

    public String getBookingStatus()                          { return bookingStatus; }
    public void setBookingStatus(String bookingStatus)        { this.bookingStatus = bookingStatus; }

    public Timestamp getBookedAt()                    { return bookedAt; }
    public void setBookedAt(Timestamp bookedAt)       { this.bookedAt = bookedAt; }

    // ── Joined / Transient Fields ─────────────────────────────────────────────
    public String getRoomNumber()                     { return roomNumber; }
    public void setRoomNumber(String roomNumber)      { this.roomNumber = roomNumber; }

    public String getRoomType()                       { return roomType; }
    public void setRoomType(String roomType)          { this.roomType = roomType; }

    public double getPricePerNight()                      { return pricePerNight; }
    public void setPricePerNight(double pricePerNight)    { this.pricePerNight = pricePerNight; }

    @Override
    public String toString() {
        return "Booking{id=" + bookingId + ", guest=" + guestName + ", room=" + roomId + ", status=" + bookingStatus + "}";
    }
}
