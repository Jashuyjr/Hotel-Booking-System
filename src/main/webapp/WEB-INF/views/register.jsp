<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Account — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lato:wght@400;700&display=swap" rel="stylesheet">
</head>
<body class="confirmation-page">
    <header class="site-header">
        <div class="header-inner container">
            <div class="logo">
                <span class="logo-icon">✦</span>
                <span class="logo-name">Grand Vista</span>
            </div>
        </div>
    </header>

    <main class="main-content container">
        <div class="booking-form-panel" style="max-width: 450px; margin: 50px auto;">
            <h1 class="form-title">Join Us</h1>
            <p class="form-subtitle">Register to manage your bookings and preferences.</p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            
            <form action="register" method="POST" class="booking-form">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Create Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-submit" style="width: 100%;">Create Account</button>
                </div>
            </form>
            <p style="text-align: center; margin-top: 20px;">
                <a href="rooms" style="color: var(--color-gold-dark); font-weight: 700;">← Back to Home</a>
            </p>
        </div>
    </main>
</body>
</html>