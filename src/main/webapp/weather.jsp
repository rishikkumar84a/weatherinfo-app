<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather in ${cityName} - AuraWeather</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="${weatherCondition}-bg">
    <div class="container">
        <!-- Header with Back Button -->
        <header class="header weather-header">
            <div class="header-nav">
                <a href="index.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Back to Search
                </a>
                <div class="logo">
                    <i class="fas fa-cloud-sun weather-icon"></i>
                    <h1>AuraWeather</h1>
                </div>
            </div>
        </header>

        <!-- Main Weather Display -->
        <main class="weather-main">
            <!-- Current Weather Card -->
            <div class="current-weather-card">
                <div class="weather-header-info">
                    <div class="location">
                        <h2><i class="fas fa-map-marker-alt"></i> ${cityName}, ${country}</h2>
                        <p class="update-time">Last updated: <span id="currentTime"></span></p>
                    </div>
                </div>

                <div class="weather-main-info">
                    <div class="temperature-section">
                        <div class="main-temp">
                            <span class="temp-value">${temperature}</span>
                            <span class="temp-unit">°C</span>
                        </div>
                        <div class="feels-like">
                            Feels like ${feelsLike}°C
                        </div>
                        <div class="weather-description">
                            <img src="https://openweathermap.org/img/wn/${weatherIcon}@2x.png" 
                                 alt="${description}" class="weather-icon-img">
                            <span>${description}</span>
                        </div>
                    </div>

                    <div class="weather-details">
                        <div class="detail-item">
                            <i class="fas fa-tint detail-icon"></i>
                            <div class="detail-info">
                                <span class="detail-label">Humidity</span>
                                <span class="detail-value">${humidity}%</span>
                            </div>
                        </div>
                        
                        <c:if test="${not empty windSpeed}">
                        <div class="detail-item">
                            <i class="fas fa-wind detail-icon"></i>
                            <div class="detail-info">
                                <span class="detail-label">Wind Speed</span>
                                <span class="detail-value">${windSpeed} km/h</span>
                            </div>
                        </div>
                        </c:if>

                        <div class="detail-item">
                            <i class="fas fa-sun detail-icon"></i>
                            <div class="detail-info">
                                <span class="detail-label">Sunrise</span>
                                <span class="detail-value">${sunrise}</span>
                            </div>
                        </div>

                        <div class="detail-item">
                            <i class="fas fa-moon detail-icon"></i>
                            <div class="detail-info">
                                <span class="detail-label">Sunset</span>
                                <span class="detail-value">${sunset}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Weather Advice -->
                <c:if test="${not empty weatherAdvice}">
                <div class="weather-advice">
                    <div class="advice-content">
                        <i class="fas fa-lightbulb advice-icon"></i>
                        <p>${weatherAdvice}</p>
                    </div>
                </div>
                </c:if>
            </div>

            <!-- 5-Day Forecast -->
            <c:if test="${not empty forecastList}">
            <div class="forecast-section">
                <h3><i class="fas fa-calendar-alt"></i> 5-Day Forecast</h3>
                <div class="forecast-grid">
                    <c:forEach var="forecast" items="${forecastList}" varStatus="status">
                    <div class="forecast-card">
                        <div class="forecast-date">
                            <c:choose>
                                <c:when test="${status.index == 0}">Tomorrow</c:when>
                                <c:otherwise>${forecast.date}</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="forecast-icon">
                            <img src="https://openweathermap.org/img/wn/${forecast.icon}@2x.png" 
                                 alt="${forecast.description}">
                        </div>
                        <div class="forecast-temps">
                            <span class="forecast-high">${forecast.tempMax}°</span>
                            <span class="forecast-low">${forecast.tempMin}°</span>
                        </div>
                        <div class="forecast-desc">${forecast.description}</div>
                    </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <!-- Search Again Section -->
            <div class="search-again-section">
                <h4>Search Another City</h4>
                <form action="weather" method="post" class="search-again-form">
                    <div class="input-group">
                        <input type="text" 
                               name="city" 
                               placeholder="Enter another city name" 
                               required 
                               class="city-input">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2025 AuraWeather. Weather data provided by OpenWeatherMap</p>
        </footer>
    </div>

    <!-- Weather animation overlay -->
    <div class="weather-animation-overlay">
        <c:choose>
            <c:when test="${weatherCondition == 'rain'}">
                <div class="rain-animation">
                    <c:forEach begin="1" end="50">
                        <div class="raindrop"></div>
                    </c:forEach>
                </div>
            </c:when>
            <c:when test="${weatherCondition == 'snow'}">
                <div class="snow-animation">
                    <c:forEach begin="1" end="50">
                        <div class="snowflake">❄</div>
                    </c:forEach>
                </div>
            </c:when>
        </c:choose>
    </div>

    <script>
        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('en-US', { 
                hour12: true, 
                hour: '2-digit', 
                minute: '2-digit' 
            });
            document.getElementById('currentTime').textContent = timeString;
        }

        // Initialize time and update every minute
        updateTime();
        setInterval(updateTime, 60000);

        // Animate weather cards on load
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.current-weather-card, .forecast-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.classList.add('animate-in');
                }, index * 100);
            });

            // Add hover effects to forecast cards
            const forecastCards = document.querySelectorAll('.forecast-card');
            forecastCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px) scale(1.02)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });
        });

        // Add search form submission handling
        document.querySelector('.search-again-form').addEventListener('submit', function() {
            const button = this.querySelector('.search-btn');
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        });
    </script>
</body>
</html>
