<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%--
    confirmation.jsp — View (JSP) — Booking Confirmation
    ============================================================
    Displays booking details after successful JDBC INSERT.
    Data populated by ConfirmationServlet via request attributes.

    Demonstrates: EL expressions, JSTL fmt tag for formatting
    ============================================================
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
</head>
<body class="confirmation-page">

<header class="site-header">
    <div class="header-inner container">
        <div class="logo">
            <span class="logo-icon">✦</span>
            <div>
                <span class="logo-name">Grand Vista</span>
                <span class="logo-sub">HOTEL &amp; RESORT</span>
            </div>
        </div>
    </div>
</header>

<main class="main-content container">
    <div class="confirmation-wrapper">

        <!-- Success Banner -->
        <div class="confirmation-hero">
            <div class="success-icon">✓</div>
            <h1 class="confirmation-title">Booking Confirmed!</h1>
            <p class="confirmation-subtitle">
                Thank you, <strong>${booking.guestName}</strong>! Your reservation is confirmed.
                A confirmation has been sent to <strong>${booking.guestEmail}</strong>.
            </p>
            <div class="booking-ref">
                <span class="ref-label">Booking Reference</span>
                <span class="ref-number">#GV<fmt:formatNumber value="${booking.bookingId}" minIntegerDigits="5"/></span>
            </div>
        </div>

        <!-- Booking Detail Card -->
        <div class="confirmation-card">
            <div class="conf-section">
                <h2 class="conf-section-title">Reservation Details</h2>

                <div class="conf-grid">
                    <div class="conf-item">
                        <span class="conf-label">Guest Name</span>
                        <span class="conf-value">${booking.guestName}</span>
                    </div>
                    <div class="conf-item">
                        <span class="conf-label">Email</span>
                        <span class="conf-value">${booking.guestEmail}</span>
                    </div>
                    <c:if test="${not empty booking.guestPhone}">
                    <div class="conf-item">
                        <span class="conf-label">Phone</span>
                        <span class="conf-value">${booking.guestPhone}</span>
                    </div>
                    </c:if>
                    <div class="conf-item">
                        <span class="conf-label">Room Type</span>
                        <span class="conf-value">${booking.roomType}</span>
                    </div>
                    <div class="conf-item">
                        <span class="conf-label">Room Number</span>
                        <span class="conf-value">${booking.roomNumber}</span>
                    </div>
                    <div class="conf-item">
                        <span class="conf-label">Check-In</span>
                        <span class="conf-value">
                            <fmt:formatDate value="${booking.checkInDate}" pattern="EEEE, dd MMMM yyyy"/>
                        </span>
                    </div>
                    <div class="conf-item">
                        <span class="conf-label">Check-Out</span>
                        <span class="conf-value">
                            <fmt:formatDate value="${booking.checkOutDate}" pattern="EEEE, dd MMMM yyyy"/>
                        </span>
                    </div>
                    <div class="conf-item">
                        <span class="conf-label">Duration</span>
                        <span class="conf-value">${booking.totalNights} Night<c:if test="${booking.totalNights > 1}">s</c:if></span>
                    </div>
                </div>
            </div>

            <!-- Price Breakdown -->
            <div class="conf-section conf-price-section">
                <h2 class="conf-section-title">Price Summary</h2>
                <div class="price-breakdown">
                    <div class="price-row">
                        <span>
                            <fmt:formatNumber value="${booking.pricePerNight}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                            × ${booking.totalNights} night<c:if test="${booking.totalNights > 1}">s</c:if>
                        </span>
                        <span>
                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="price-row price-total-row">
                        <strong>Total Charged</strong>
                        <strong class="total-amount">
                            <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                        </strong>
                    </div>
                </div>
            </div>

            <!-- Special Requests -->
            <c:if test="${not empty booking.specialRequests}">
            <div class="conf-section">
                <h2 class="conf-section-title">Special Requests</h2>
                <p class="special-requests-text">${booking.specialRequests}</p>
            </div>
            </c:if>

            <!-- Status Badge -->
            <div class="conf-status">
                <span class="status-badge confirmed">
                    ✓ ${booking.bookingStatus}
                </span>
                <span class="booked-at">
                    Booked on: <fmt:formatDate value="${booking.bookedAt}" pattern="dd MMM yyyy, hh:mm a"/>
                </span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="conf-actions">
            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">
                Browse More Rooms
            </a>
            <button onclick="window.print()" class="btn btn-secondary">
                Print Confirmation
            </button>
        </div>

        <!-- Tech Footer Note (for educational context) -->
        <div class="tech-note">
            <strong>System Note (Educational):</strong>
            This confirmation was generated by <code>ConfirmationServlet.doGet()</code> →
            fetched via <code>BookingDAO.getBookingById(${booking.bookingId})</code> using a
            JDBC JOIN query → rendered by <code>confirmation.jsp</code> using JSTL EL.
        </div>
    </div>
</main>

<footer class="site-footer">
    <div class="container footer-inner">
        <div class="footer-brand">
            <span class="logo-icon">✦</span>
            <span class="logo-name">Grand Vista Hotel</span>
        </div>
        <p class="footer-copy">© 2025 Grand Vista Hotel &amp; Resort. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
