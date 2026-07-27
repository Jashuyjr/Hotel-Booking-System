<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dining — Grand Vista Hotel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@400;700&display=swap" rel="stylesheet">
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
            <a href="${pageContext.request.contextPath}/dining" class="nav-link active">Dining</a>
            <a href="${pageContext.request.contextPath}/spa" class="nav-link">Spa</a>
        </nav>
    </div>
</header>
<main class="main-content container">
    <section class="hero" style="border-radius: 16px; margin-bottom: 40px;">
        <div class="hero-content">
            <h1 class="hero-title">Culinary Excellence</h1>
            <p class="hero-desc">From fine dining to casual bites, experience flavors crafted by world-class chefs.</p>
        </div>
    </section>
</main>
</body>
</html>