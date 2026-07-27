<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error — Grand Vista Hotel</title>
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
    </div>
</header>
<main class="main-content container">
    <div class="error-page">
        <div class="error-icon">⚠</div>
        <h1>Something went wrong</h1>
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">${errorMessage}</c:when>
                <c:otherwise>An unexpected error occurred. Please try again.</c:otherwise>
            </c:choose>
        </p>
        <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">Return to Rooms</a>
    </div>
</main>
</body>
</html>
