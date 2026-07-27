package com.hotel.model;

/**
 * Room.java - Model (Java Bean)
 * ============================================================
 * SYLLABUS TOPIC: MVC Architecture — MODEL layer
 *
 * Represents a hotel room entity. This is a plain Java Bean
 * (POJO) that maps directly to the 'rooms' table in the DB.
 * Java Beans follow the convention: private fields + public
 * getters/setters + no-arg constructor.
 * ============================================================
 */
public class Room {

    private int     roomId;
    private String  roomNumber;
    private String  roomType;
    private int     capacity;
    private double  pricePerNight;
    private String  description;
    private String  amenities;
    private boolean isAvailable;
    private String  imageUrl;

    // ── No-Arg Constructor (required by Java Bean spec) ──────────────────────
    public Room() {}

    // ── All-Args Constructor (convenience) ───────────────────────────────────
    public Room(int roomId, String roomNumber, String roomType, int capacity,
                double pricePerNight, String description, String amenities,
                boolean isAvailable, String imageUrl) {
        this.roomId       = roomId;
        this.roomNumber   = roomNumber;
        this.roomType     = roomType;
        this.capacity     = capacity;
        this.pricePerNight = pricePerNight;
        this.description  = description;
        this.amenities    = amenities;
        this.isAvailable  = isAvailable;
        this.imageUrl     = imageUrl;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────
    public int getRoomId()                  { return roomId; }
    public void setRoomId(int roomId)       { this.roomId = roomId; }

    public String getRoomNumber()                   { return roomNumber; }
    public void setRoomNumber(String roomNumber)    { this.roomNumber = roomNumber; }

    public String getRoomType()                     { return roomType; }
    public void setRoomType(String roomType)        { this.roomType = roomType; }

    public int getCapacity()                        { return capacity; }
    public void setCapacity(int capacity)           { this.capacity = capacity; }

    public double getPricePerNight()                    { return pricePerNight; }
    public void setPricePerNight(double pricePerNight)  { this.pricePerNight = pricePerNight; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public String getAmenities()                        { return amenities; }
    public void setAmenities(String amenities)          { this.amenities = amenities; }

    public boolean isAvailable()                        { return isAvailable; }
    public void setAvailable(boolean available)         { isAvailable = available; }

    public String getImageUrl()                         { return imageUrl; }
    public void setImageUrl(String imageUrl)            { this.imageUrl = imageUrl; }

    @Override
    public String toString() {
        return "Room{id=" + roomId + ", number=" + roomNumber + ", type=" + roomType + ", price=" + pricePerNight + "}";
    }
}
