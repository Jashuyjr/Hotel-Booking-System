<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
</head>
<body>
<header class="site-header">
    <div class="header-inner container">
        <div class="logo">
            <span class="logo-icon">✦</span>
            <div><span class="logo-name">Grand Vista</span><span class="logo-sub">HOTEL &amp; RESORT</span></div>
        </div>
        <nav class="site-nav">
            <a href="${pageContext.request.contextPath}/rooms" class="nav-link">Rooms</a>
            <a href="#" class="nav-link active">Contact</a>
        </nav>
    </div>
</header>

<main class="main-content container">
    <section class="booking-form-panel" style="max-width: 800px; margin: 0 auto;">
        <h1 class="form-title">Get in Touch</h1>
        <p class="form-subtitle">Have questions? We'd love to hear from you.</p>
        
        <form action="${pageContext.request.contextPath}/contact" method="POST" class="booking-form">
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Message</label>
                <textarea name="message" class="form-control form-textarea" rows="5" required></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-submit">Send Message</button>
            </div>
        </form>
    </section>
</main>
</body>
</html>