<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%--
    index.jsp — View (JSP)
    ============================================================
    SYLLABUS TOPIC: JSP, MVC Architecture — VIEW layer

    ┌─────────────────────────────────────────────────────────┐
    │               JSP LIFE CYCLE (Key Concept)              │
    ├─────────────────────────────────────────────────────────┤
    │ 1. TRANSLATION: Container converts .jsp → _Servlet.java │
    │    (happens once, or whenever JSP is modified)          │
    │                                                         │
    │ 2. COMPILATION: Generated Java class is compiled        │
    │                                                         │
    │ 3. LOADING & INSTANTIATION: Like a normal Servlet       │
    │                                                         │
    │ 4. INITIALIZATION: jspInit() called once                │
    │                                                         │
    │ 5. REQUEST PROCESSING: _jspService() called per request │
    │    - Scriptlets/EL expressions are evaluated here       │
    │    - HTML is written to the response output stream      │
    │                                                         │
    │ 6. DESTRUCTION: jspDestroy() called once on shutdown    │
    └─────────────────────────────────────────────────────────┘

    This JSP receives data from RoomSearchServlet via request
    attributes (${rooms}, ${activeFilter}) and renders room cards.

    HTML5 Semantic Elements used: <header>, <main>, <section>,
    <article>, <footer>, <nav>

    AngularJS Integration: The filter bar uses ng-click to
    redirect with type filter (simple client-side navigation).
    ============================================================
--%>
<!DOCTYPE html>
<html lang="en" ng-app="hotelApp">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grand Vista Hotel — Rooms</title>
    <!-- CSS3 Stylesheet (Box Model, Flexbox, Grid, Custom Properties) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <!-- AngularJS 1.x CDN -->
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.8.3/angular.min.js"></script>
</head>
<body ng-controller="FilterController">

<!-- ══════════════════════════════════════════════════════════
     HEADER — Semantic HTML5 <header> element
     ══════════════════════════════════════════════════════════ -->
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
    		<a href="${pageContext.request.contextPath}/rooms" class="nav-link active">Rooms</a>
    		<a href="${pageContext.request.contextPath}/register" class="nav-link">Register</a>
    		<a href="${pageContext.request.contextPath}/dining" class="nav-link">Dining</a>
    		<a href="${pageContext.request.contextPath}/spa" class="nav-link">Spa</a>
    		<a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
		</nav>
    </div>
</header>

<!-- ══════════════════════════════════════════════════════════
     HERO SECTION
     ══════════════════════════════════════════════════════════ -->
<section class="hero">
    <div class="hero-content">
        <p class="hero-sub">Welcome to Luxury</p>
        <h1 class="hero-title">Find Your Perfect Room</h1>
        <p class="hero-desc">Experience unparalleled comfort in our handcrafted spaces, designed for those who appreciate the finest things in life.</p>
    </div>
</section>

<!-- ══════════════════════════════════════════════════════════
     MAIN CONTENT — Semantic HTML5 <main>
     ══════════════════════════════════════════════════════════ -->
<main class="main-content container">

    <!-- Filter Bar — AngularJS ng-click updates the Java URL -->
    <section class="filter-section" aria-label="Room type filter">
        <h2 class="section-title">Available Rooms</h2>
        <div class="filter-bar">
            <c:forEach var="type" items="${roomTypes}">
                <a href="${pageContext.request.contextPath}/rooms<c:if test='${type != "All"}'>?type=${type}</c:if>"
                   class="filter-btn <c:if test='${activeFilter == type}'>active</c:if>">
                    ${type}
                </a>
            </c:forEach>
        </div>
    </section>

    <!-- Room Cards Grid -->
    <section class="rooms-grid" aria-label="Room listings">

        <c:choose>
            <c:when test="${empty rooms}">
                <!-- Empty state -->
                <div class="empty-state">
                    <p class="empty-icon">🏨</p>
                    <h3>No rooms available</h3>
                    <p>No ${activeFilter} rooms are currently available. Please try another category.</p>
                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">View All Rooms</a>
                </div>
            </c:when>
            <c:otherwise>
                <%-- JSTL c:forEach — iterates the rooms List set by the Servlet --%>
                <c:forEach var="room" items="${rooms}">
                    <article class="room-card">
                        <!-- Room type badge -->
                        <div class="room-badge ${room.roomType.toLowerCase()}">${room.roomType}</div>

                        <!-- Room visual placeholder (CSS-styled) -->
                        <div class="room-image room-img-${room.roomType.toLowerCase()}">
                            <div class="room-number-overlay">
                                <span>Room ${room.roomNumber}</span>
                            </div>
                        </div>

                        <!-- Card Body — CSS Box Model demo: padding, border, margin -->
                        <div class="room-card-body">
                            <div class="room-header">
                                <h3 class="room-title">${room.roomType} Room</h3>
                                <div class="room-price">
                                    <span class="price-amount">
                                        <fmt:formatNumber value="${room.pricePerNight}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                                    </span>
                                    <span class="price-unit">/night</span>
                                </div>
                            </div>

                            <p class="room-desc">${room.description}</p>

                            <div class="room-meta">
                                <span class="meta-item">
                                    <span class="meta-icon">👤</span>
                                    Up to ${room.capacity} guests
                                </span>
                                <span class="meta-item">
                                    <span class="meta-icon">🛏️</span>
                                    Room ${room.roomNumber}
                                </span>
                            </div>

                            <!-- Amenities (split by comma from DB) -->
                            <div class="amenities">
                                <c:forEach var="amenity" items="${room.amenities.split(',')}" end="3">
                                    <span class="amenity-tag">${amenity.trim()}</span>
                                </c:forEach>
                            </div>

                            <!-- CTA Button → links to BookingServlet GET /book?roomId= -->
                            <a href="${pageContext.request.contextPath}/book?roomId=${room.roomId}"
                               class="btn btn-book">
                                Book This Room
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </section>
</main>

<!-- ══════════════════════════════════════════════════════════
     FOOTER — Semantic HTML5 <footer>
     ══════════════════════════════════════════════════════════ -->
<footer class="site-footer">
    <div class="container footer-inner">
        <div class="footer-brand">
            <span class="logo-icon">✦</span>
            <span class="logo-name">Grand Vista Hotel</span>
        </div>
        <p class="footer-copy">© 2025 Grand Vista Hotel &amp; Resort. All rights reserved.</p>
        <p class="footer-tech">Built with Java Servlets · JSP · AngularJS 1.x · JDBC</p>
    </div>
</footer>

<!-- AngularJS App Script -->
<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>
