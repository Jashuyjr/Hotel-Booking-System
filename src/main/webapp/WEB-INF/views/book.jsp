<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%--
    book.jsp — View (JSP) — Booking Form
    ============================================================
    SYLLABUS TOPICS:
      - JSP: Expression Language ${room.xxx}, JSTL tags
      - AngularJS: Module, Controller, Data Binding, Form Validation
      - HTML5: Semantic form elements, input types
      - CSS3: Box Model for form layout

    AngularJS Concepts demonstrated:
      - ng-app / ng-controller: Bootstrap AngularJS app
      - ng-model: Two-way data binding (form field ↔ $scope variable)
      - ng-submit: Handle form submission event
      - ng-show / ng-if: Conditional DOM rendering
      - $scope: The "glue" between controller and view
      - Form Validation: required, ng-minlength, email directives
        $valid, $invalid, $dirty, $error properties on form object
      - $http.post(): AJAX-style POST to BookingServlet
        (falls back to native form submit for simplicity here)
    ============================================================
--%>
<!DOCTYPE html>
<html lang="en" ng-app="hotelApp">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Room — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.8.3/angular.min.js"></script>
</head>
<body ng-controller="BookingController">

<!-- HEADER -->
<header class="site-header">
    <div class="header-inner container">
        <div class="logo">
            <span class="logo-icon">✦</span>
            <div>
                <span class="logo-name">Grand Vista</span>
                <span class="logo-sub">HOTEL &amp; RESORT</span>
            </div>
        </div>
        <nav class="site-nav">
            <a href="${pageContext.request.contextPath}/rooms" class="nav-link">← Back to Rooms</a>
        </nav>
    </div>
</header>

<main class="main-content container">
    <div class="booking-layout">

        <!-- ══ LEFT: Room Summary ════════════════════════════════════════════ -->
        <aside class="room-summary-panel">
            <div class="summary-card">
                <div class="summary-header">
                    <span class="summary-label">You're Booking</span>
                    <div class="summary-badge ${room.roomType.toLowerCase()}">${room.roomType}</div>
                </div>

                <div class="summary-room-image room-img-${room.roomType.toLowerCase()} summary-img"></div>

                <div class="summary-details">
                    <div class="summary-row">
                        <span class="summary-key">Room Number</span>
                        <span class="summary-val">${room.roomNumber}</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-key">Type</span>
                        <span class="summary-val">${room.roomType}</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-key">Capacity</span>
                        <span class="summary-val">${room.capacity} Guests</span>
                    </div>
                    <div class="summary-row summary-price-row">
                        <span class="summary-key">Price</span>
                        <span class="summary-val price-highlight">
                            <fmt:formatNumber value="${room.pricePerNight}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                            <small>/night</small>
                        </span>
                    </div>
                </div>

                <!-- AngularJS Data Binding: Dynamic price calculation -->
                <div class="price-calc-box" ng-show="totalNights > 0">
                    <div class="calc-row">
                        <span>
                            <fmt:formatNumber value="${room.pricePerNight}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                            × {{totalNights}} night<span ng-if="totalNights > 1">s</span>
                        </span>
                        <span>{{formatPrice(totalPrice)}}</span>
                    </div>
                    <div class="calc-row calc-total">
                        <span>Total</span>
                        <strong>{{formatPrice(totalPrice)}}</strong>
                    </div>
                </div>

                <div class="summary-amenities">
                    <p class="amenity-label">Included Amenities</p>
                    <c:forEach var="amenity" items="${room.amenities.split(',')}">
                        <span class="amenity-tag">${amenity.trim()}</span>
                    </c:forEach>
                </div>
            </div>
        </aside>

        <!-- ══ RIGHT: Booking Form ════════════════════════════════════════════ -->
        <section class="booking-form-panel">
            <h1 class="form-title">Complete Your Booking</h1>
            <p class="form-subtitle">Fill in your details below. All fields marked * are required.</p>

            <!-- Server-side error message (from Servlet) -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <!--
                AngularJS Form: name="bookingForm" enables form validation object
                ng-submit: Only fires if $http or AngularJS handles submission
                           Here we use native action + ng enhancements for demo
                novalidate: Disables native HTML5 validation so AngularJS takes over
            -->
            <form name="bookingForm"
                  action="${pageContext.request.contextPath}/book"
                  method="POST"
                  ng-submit="submitBooking(bookingForm, $event)"
                  novalidate
                  class="booking-form">

                <!-- Hidden field: passes roomId to BookingServlet POST handler -->
                <input type="hidden" name="roomId" value="${room.roomId}">

                <!-- ── Section: Guest Information ──────────────────────────── -->
                <fieldset class="form-section">
                    <legend class="form-section-title">Guest Information</legend>

                    <!-- Full Name Field -->
                    <div class="form-group"
                         ng-class="{'has-error': bookingForm.guestName.$invalid && bookingForm.guestName.$dirty,
                                    'has-success': bookingForm.guestName.$valid && bookingForm.guestName.$dirty}">
                        <label for="guestName" class="form-label">Full Name *</label>
                        <input type="text"
                               id="guestName"
                               name="guestName"
                               class="form-control"
                               ng-model="booking.guestName"
                               required
                               ng-minlength="3"
                               placeholder="e.g. Rahul Sharma">
                        <!-- AngularJS Validation Messages (ng-show uses $error & $dirty) -->
                        <span class="error-msg" ng-show="bookingForm.guestName.$dirty && bookingForm.guestName.$error.required">
                            Full name is required.
                        </span>
                        <span class="error-msg" ng-show="bookingForm.guestName.$dirty && bookingForm.guestName.$error.minlength">
                            Name must be at least 3 characters.
                        </span>
                    </div>

                    <!-- Email Field -->
                    <div class="form-group"
                         ng-class="{'has-error': bookingForm.guestEmail.$invalid && bookingForm.guestEmail.$dirty,
                                    'has-success': bookingForm.guestEmail.$valid && bookingForm.guestEmail.$dirty}">
                        <label for="guestEmail" class="form-label">Email Address *</label>
                        <input type="email"
                               id="guestEmail"
                               name="guestEmail"
                               class="form-control"
                               ng-model="booking.guestEmail"
                               required
                               placeholder="e.g. rahul@email.com">
                        <span class="error-msg" ng-show="bookingForm.guestEmail.$dirty && bookingForm.guestEmail.$error.required">
                            Email address is required.
                        </span>
                        <span class="error-msg" ng-show="bookingForm.guestEmail.$dirty && bookingForm.guestEmail.$error.email">
                            Please enter a valid email address.
                        </span>
                    </div>

                    <!-- Phone Field -->
                    <div class="form-group">
                        <label for="guestPhone" class="form-label">Phone Number</label>
                        <input type="tel"
                               id="guestPhone"
                               name="guestPhone"
                               class="form-control"
                               ng-model="booking.guestPhone"
                               ng-pattern="/^[0-9]{10}$/"
                               placeholder="10-digit mobile number">
                        <span class="error-msg" ng-show="bookingForm.guestPhone.$dirty && bookingForm.guestPhone.$error.pattern">
                            Please enter a valid 10-digit phone number.
                        </span>
                    </div>
                </fieldset>

                <!-- ── Section: Stay Dates ─────────────────────────────────── -->
                <fieldset class="form-section">
                    <legend class="form-section-title">Stay Dates</legend>

                    <div class="form-row">
                        <!-- Check-In Date -->
                        <div class="form-group"
                             ng-class="{'has-error': bookingForm.checkInDate.$invalid && bookingForm.checkInDate.$dirty}">
                            <label for="checkInDate" class="form-label">Check-In Date *</label>
                            <input type="date"
                                   id="checkInDate"
                                   name="checkInDate"
                                   class="form-control"
                                   ng-model="booking.checkInDate"
                                   ng-change="calculateNights()"
                                   required
                                   min="${todayDate}">
                            <span class="error-msg" ng-show="bookingForm.checkInDate.$dirty && bookingForm.checkInDate.$error.required">
                                Check-in date is required.
                            </span>
                        </div>

                        <!-- Check-Out Date -->
                        <div class="form-group"
                             ng-class="{'has-error': bookingForm.checkOutDate.$invalid && bookingForm.checkOutDate.$dirty}">
                            <label for="checkOutDate" class="form-label">Check-Out Date *</label>
                            <input type="date"
                                   id="checkOutDate"
                                   name="checkOutDate"
                                   class="form-control"
                                   ng-model="booking.checkOutDate"
                                   ng-change="calculateNights()"
                                   required
                                   min="${todayDate}">
                            <span class="error-msg" ng-show="bookingForm.checkOutDate.$dirty && bookingForm.checkOutDate.$error.required">
                                Check-out date is required.
                            </span>
                        </div>
                    </div>

                    <!-- Date Error (AngularJS logic) -->
                    <div class="alert alert-error" ng-show="dateError">
                        {{dateError}}
                    </div>

                    <!-- Night count (AngularJS two-way binding) -->
                    <div class="nights-display" ng-show="totalNights > 0">
                        <span class="nights-icon">🌙</span>
                        <strong>{{totalNights}}</strong> night<span ng-if="totalNights > 1">s</span> selected
                    </div>
                </fieldset>

                <!-- ── Section: Special Requests ─────────────────────────── -->
                <fieldset class="form-section">
                    <legend class="form-section-title">Special Requests <span class="optional">(Optional)</span></legend>
                    <div class="form-group">
                        <label for="specialRequests" class="form-label">Requests or Notes</label>
                        <textarea id="specialRequests"
                                  name="specialRequests"
                                  class="form-control form-textarea"
                                  ng-model="booking.specialRequests"
                                  placeholder="e.g. Early check-in, flowers in room, ground floor preference..."
                                  rows="3"></textarea>
                        <!-- Real-time character count — AngularJS data binding -->
                        <span class="char-count">{{(booking.specialRequests || '').length}} characters</span>
                    </div>
                </fieldset>

                <!-- ── Submit Button ──────────────────────────────────────── -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">Cancel</a>
                    <button type="submit"
                            class="btn btn-primary btn-submit"
                            ng-disabled="bookingForm.$invalid || totalNights <= 0">
                        <span ng-if="!submitting">Confirm Booking</span>
                        <span ng-if="submitting">Processing...</span>
                    </button>
                </div>

                <!-- Form state summary (educational — shows AngularJS form states) -->
                <div class="form-debug" ng-if="showDebug">
                    <strong>AngularJS Form State:</strong>
                    $valid: {{bookingForm.$valid}} |
                    $dirty: {{bookingForm.$dirty}} |
                    Nights: {{totalNights}} |
                    Total: {{formatPrice(totalPrice)}}
                </div>
            </form>
        </section>
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

<!-- Pass server-side room price to AngularJS scope via JSP Expression Language -->
<script>
    // Bridge: JSP → AngularJS
    // JSP EL evaluates ${room.pricePerNight} on the server before AngularJS sees this file
    window.ROOM_PRICE_PER_NIGHT = parseFloat("${room.pricePerNight}");
</script>
<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>
