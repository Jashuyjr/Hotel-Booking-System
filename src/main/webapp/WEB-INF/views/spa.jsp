<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Spa & Wellness — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
            <a href="${pageContext.request.contextPath}/dining" class="nav-link">Dining</a>
            <a href="${pageContext.request.contextPath}/spa" class="nav-link active">Spa</a>
        </nav>
    </div>
</header>
<main class="main-content container">
    <section class="hero" style="border-radius: 16px; background: linear-gradient(135deg, #16213E 0%, #0F3460 100%);">
        <div class="hero-content">
            <h1 class="hero-title">Serenity & Wellness</h1>
            <p class="hero-desc">Rejuvenate your mind and body with our exclusive spa treatments.</p>
        </div>
    </section>
</main>
</body>
</html>
