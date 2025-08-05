<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraWeather - Your Personal Weather Companion</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="default-bg">
    <div class="container">
        <!-- Header Section -->
        <header class="header">
            <div class="logo">
                <i class="fas fa-cloud-sun weather-icon"></i>
                <h1>AuraWeather</h1>
            </div>
            <p class="tagline">Your Personal Weather Companion</p>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="welcome-section">
                <h2>Discover Weather Like Never Before</h2>
                <p class="description">
                    Get real-time weather updates, 5-day forecasts, and personalized weather advice 
                    for any city around the world. Experience weather data with stunning visuals 
                    that adapt to current conditions.
                </p>
            </div>

            <!-- Search Form -->
            <div class="search-container">
                <form action="weather" method="post" class="weather-form">
                    <div class="input-group">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" 
                               name="city" 
                               id="cityInput" 
                               placeholder="Enter city name (e.g., London, New York, Tokyo)" 
                               required 
                               autocomplete="off"
                               class="city-input">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-arrow-right"></i>
                            Get Weather
                        </button>
                    </div>
                </form>
            </div>

            <!-- Features Section -->
            <div class="features-section">
                <h3>Why Choose AuraWeather?</h3>
                <div class="features-grid">
                    <div class="feature-card">
                        <i class="fas fa-eye feature-icon"></i>
                        <h4>Dynamic Visuals</h4>
                        <p>Background adapts to current weather conditions</p>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-calendar-alt feature-icon"></i>
                        <h4>5-Day Forecast</h4>
                        <p>Plan ahead with detailed weather predictions</p>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-lightbulb feature-icon"></i>
                        <h4>Smart Advice</h4>
                        <p>Get personalized recommendations based on weather</p>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-mobile-alt feature-icon"></i>
                        <h4>Responsive Design</h4>
                        <p>Perfect experience on all devices</p>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2025 AuraWeather. Powered by OpenWeatherMap API</p>
        </footer>
    </div>

    <!-- Loading overlay (hidden by default) -->
    <div id="loadingOverlay" class="loading-overlay" style="display: none;">
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Fetching weather data...</p>
        </div>
    </div>

    <script>
        // Show loading overlay when form is submitted
        document.querySelector('.weather-form').addEventListener('submit', function() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        });

        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            const cityInput = document.getElementById('cityInput');
            
            // Focus animation
            cityInput.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            cityInput.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
            });

            // Animate feature cards on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate-in');
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.feature-card').forEach(card => {
                observer.observe(card);
            });
        });
    </script>
</body>
</html>
