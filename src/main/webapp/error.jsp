<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - AuraWeather</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body class="default-bg">
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="logo">
                <i class="fas fa-cloud-sun weather-icon"></i>
                <h1>AuraWeather</h1>
            </div>
        </header>

        <!-- Error Content -->
        <main class="main-content">
            <div class="error-section">
                <div class="error-card">
                    <div class="error-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h2>Oops! Something went wrong</h2>
                    <c:choose>
                        <c:when test="${not empty error}">
                            <p class="error-message">${error}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="error-message">We're experiencing some technical difficulties. Please try again later.</p>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="error-actions">
                        <a href="index.jsp" class="btn-primary">
                            <i class="fas fa-home"></i>
                            Back to Home
                        </a>
                        <button onclick="history.back()" class="btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Go Back
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2025 AuraWeather. Your Personal Weather Companion</p>
        </footer>
    </div>

    <style>
        .error-section {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 60vh;
        }

        .error-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
            max-width: 500px;
            width: 100%;
        }

        .error-icon {
            font-size: 4rem;
            color: #e74c3c;
            margin-bottom: 20px;
        }

        .error-card h2 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .error-message {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-primary, .btn-secondary {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .btn-secondary {
            background: rgba(255,255,255,0.8);
            color: #333;
            border: 2px solid #ddd;
        }

        .btn-secondary:hover {
            background: rgba(255,255,255,1);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        @media (max-width: 480px) {
            .error-card {
                padding: 30px 20px;
            }
            
            .error-actions {
                flex-direction: column;
            }
            
            .btn-primary, .btn-secondary {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</body>
</html>
