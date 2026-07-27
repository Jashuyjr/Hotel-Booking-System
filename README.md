# 🏨 Grand Vista Hotel Booking System
### Traditional Stack: Java Servlets · JSP · AngularJS 1.x · JDBC · MySQL

---

## 📐 Project Architecture — N-Tier Model

```
┌────────────────────────────────────────────────────────────────────┐
│                         CLIENT TIER                                │
│   Browser → HTML5/CSS3 page + AngularJS 1.x (client-side logic)   │
└──────────────────────────────┬─────────────────────────────────────┘
                               │ HTTP Request/Response
┌──────────────────────────────▼─────────────────────────────────────┐
│                    WEB / APPLICATION TIER                          │
│   Apache Tomcat 9.x                                                │
│   ┌──────────────┐   ┌─────────────────┐   ┌──────────────────┐   │
│   │  Java Servlets│   │   JSP Views     │   │  Java Beans/DAO  │   │
│   │  (Controller) │→  │  (View/HTML)    │   │  (Model/JDBC)    │   │
│   └──────────────┘   └─────────────────┘   └──────────────────┘   │
└──────────────────────────────┬─────────────────────────────────────┘
                               │ JDBC (java.sql.*)
┌──────────────────────────────▼─────────────────────────────────────┐
│                          DATA TIER                                 │
│   MySQL 8.x — hotel_booking_db                                     │
│   Tables: users, rooms, bookings                                   │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Complete File Structure

```
HotelBookingSystem/
│
├── pom.xml                              ← Maven build & dependencies
├── sql/
│   └── db.sql                          ← Database schema + seed data
│
└── src/main/
    ├── java/com/hotel/
    │   ├── model/                       ← MVC: MODEL layer (Java Beans)
    │   │   ├── Room.java
    │   │   └── Booking.java
    │   │
    │   ├── dao/                         ← Data Access Objects (JDBC)
    │   │   ├── RoomDAO.java
    │   │   └── BookingDAO.java
    │   │
    │   ├── servlet/                     ← MVC: CONTROLLER layer
    │   │   ├── RoomSearchServlet.java   ← GET /rooms
    │   │   ├── BookingServlet.java      ← GET+POST /book
    │   │   └── ConfirmationServlet.java ← GET /confirmation
    │   │
    │   └── util/
    │       └── DBUtil.java              ← JDBC Connection utility
    │
    └── webapp/
        ├── WEB-INF/
        │   ├── web.xml                  ← Deployment Descriptor
        │   └── views/                   ← MVC: VIEW layer (JSP)
        │       ├── index.jsp            ← Room listing
        │       ├── book.jsp             ← Booking form (AngularJS)
        │       ├── confirmation.jsp     ← Booking confirmed
        │       └── error.jsp            ← Error page
        │
        ├── css/
        │   └── style.css               ← CSS3 (Box Model, Grid, Flex)
        │
        └── js/
            └── app.js                  ← AngularJS module & controllers
```

---

## 🗃️ Database Schema

```sql
hotel_booking_db
├── users     (user_id, full_name, email, phone, password, created_at)
├── rooms     (room_id, room_number, room_type, capacity, price_per_night, ...)
└── bookings  (booking_id, user_id→, room_id→, check_in, check_out, total_price, ...)
```

---

## 🚀 Setup & Run Instructions

### Prerequisites
- Java JDK 11+
- Apache Tomcat 9.x
- MySQL 8.x
- Maven 3.6+

### Step 1: Database Setup
```sql
-- In MySQL Workbench or CLI:
source /path/to/HotelBookingSystem/sql/db.sql;
```

### Step 2: Configure Database Connection
Edit `src/main/java/com/hotel/util/DBUtil.java`:
```java
private static final String DB_USER     = "your_mysql_username";
private static final String DB_PASSWORD = "your_mysql_password";
```

### Step 3: Build the WAR file
```bash
cd HotelBookingSystem
mvn clean package
```

### Step 4: Deploy to Tomcat
```bash
# Copy the WAR to Tomcat's webapps directory:
cp target/hotel-booking.war $TOMCAT_HOME/webapps/

# Start Tomcat:
$TOMCAT_HOME/bin/startup.sh   # Linux/Mac
$TOMCAT_HOME/bin/startup.bat  # Windows
```

### Step 5: Access the Application
```
http://localhost:8080/hotel-booking/rooms
```

---

## 🔄 User Flow

```
1. User visits  /rooms
        ↓
   RoomSearchServlet.doGet()
        ↓
   RoomDAO.getAllAvailableRooms()  [JDBC SELECT]
        ↓
   Forward → index.jsp  [JSP renders room cards with JSTL]
        ↓
2. User clicks "Book This Room"
        ↓
   GET /book?roomId=3
        ↓
   BookingServlet.doGet()
        ↓
   RoomDAO.getRoomById(3)  [JDBC SELECT by PK]
        ↓
   Forward → book.jsp  [AngularJS form with validation]
        ↓
3. User fills form → AngularJS validates → native POST submit
        ↓
   POST /book  (form data)
        ↓
   BookingServlet.doPost()
        ↓
   BookingDAO.createBooking()  [JDBC INSERT + UPDATE transaction]
        ↓
4. Redirect → /confirmation?bookingId=7  [PRG Pattern]
        ↓
   ConfirmationServlet.doGet()
        ↓
   BookingDAO.getBookingById(7)  [JDBC SELECT with JOIN]
        ↓
   Forward → confirmation.jsp
```

---

## 📚 Syllabus Topics Coverage

| Topic | Implementation |
|-------|---------------|
| **MVC Architecture** | Model=JavaBeans/DAO, View=JSP, Controller=Servlets |
| **N-Tier Architecture** | Client/Web-App/Data tiers clearly separated |
| **HTML5 Semantic** | `<header>`, `<main>`, `<section>`, `<article>`, `<footer>`, `<fieldset>` |
| **CSS3 Box Model** | Documented in style.css with diagram |
| **CSS3 Flexbox** | Header, card body, form actions |
| **CSS3 Grid** | Rooms grid, booking layout, confirmation grid |
| **JDBC** | DBUtil, RoomDAO, BookingDAO — PreparedStatement, ResultSet, Transactions |
| **Servlets** | RoomSearchServlet, BookingServlet, ConfirmationServlet |
| **Servlet doGet()** | Room listing, booking form display, confirmation |
| **Servlet doPost()** | Booking form processing + redirect |
| **Servlet Life Cycle** | Documented in RoomSearchServlet.java |
| **JSP** | index.jsp, book.jsp, confirmation.jsp, error.jsp |
| **JSP Life Cycle** | Documented in index.jsp |
| **JSTL** | `<c:forEach>`, `<c:choose>`, `<c:if>`, `<fmt:formatNumber>` |
| **AngularJS Module** | `angular.module('hotelApp', [])` |
| **AngularJS Controllers** | FilterController, BookingController |
| **AngularJS Data Binding** | `ng-model`, `{{expression}}`, `ng-show` |
| **AngularJS Validation** | `required`, `ng-minlength`, `email`, `ng-pattern` |
| **AngularJS Directives** | `ng-app`, `ng-controller`, `ng-submit`, `ng-class`, `ng-change` |
| **AngularJS Custom Directive** | `hotelCardAnimate` directive |
| **SQL** | CREATE TABLE, INSERT, SELECT, UPDATE, JOIN, Transaction |

---

*Grand Vista Hotel Booking System — Educational Project*  
*Built with Java EE (Servlets/JSP) + AngularJS 1.x + JDBC + MySQL*
