package com.auraweather.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * WeatherServlet handles weather data requests using OpenWeatherMap API
 * Fetches current weather and 5-day forecast for the specified city
 */
@WebServlet("/weather")
public class WeatherServlet extends HttpServlet {
    
    // OpenWeatherMap API configuration
    // Use environment variable for security, fallback to default for local development
    private static final String API_KEY = System.getenv("OPENWEATHER_API_KEY") != null 
        ? System.getenv("OPENWEATHER_API_KEY") 
        : "5408a16ffce347e29361c879d"; // Fallback for local development
    private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
    private static final String FORECAST_URL = "https://api.openweathermap.org/data/2.5/forecast";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get city parameter from the form
        String city = request.getParameter("city");
        
        if (city == null || city.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a valid city name.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        try {
            // Encode city name for URL
            String encodedCity = URLEncoder.encode(city.trim(), "UTF-8");
            
            // Fetch current weather data
            JSONObject currentWeather = fetchCurrentWeather(encodedCity);
            
            // Fetch 5-day forecast data
            JSONObject forecastData = fetchForecastData(encodedCity);
            
            // Parse and set current weather attributes
            parseCurrentWeather(currentWeather, request);
            
            // Parse and set forecast attributes
            parseForecastData(forecastData, request);
            
            // Forward to weather display page
            request.getRequestDispatcher("weather.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Handle different types of errors
            String errorMessage = getErrorMessage(e);
            request.setAttribute("error", errorMessage);
            request.setAttribute("searchedCity", city);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    
    /**
     * Fetches current weather data from OpenWeatherMap API
     */
    private JSONObject fetchCurrentWeather(String city) throws IOException {
        String urlString = BASE_URL + "?q=" + city + "&appid=" + API_KEY + "&units=metric";
        return makeApiCall(urlString);
    }
    
    /**
     * Fetches 5-day forecast data from OpenWeatherMap API
     */
    private JSONObject fetchForecastData(String city) throws IOException {
        String urlString = FORECAST_URL + "?q=" + city + "&appid=" + API_KEY + "&units=metric";
        return makeApiCall(urlString);
    }
    
    /**
     * Makes HTTP GET request to the specified URL and returns JSON response
     */
    private JSONObject makeApiCall(String urlString) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(5000); // 5 seconds timeout
        connection.setReadTimeout(10000);   // 10 seconds timeout
        
        int responseCode = connection.getResponseCode();
        
        if (responseCode == 404) {
            throw new RuntimeException("CITY_NOT_FOUND");
        } else if (responseCode != 200) {
            throw new IOException("API request failed with response code: " + responseCode);
        }
        
        // Read the response
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        return new JSONObject(response.toString());
    }
    
    /**
     * Parses current weather data and sets request attributes
     */
    private void parseCurrentWeather(JSONObject weatherData, HttpServletRequest request) {
        try {
            // Basic location and weather info
            String cityName = weatherData.getString("name");
            String country = weatherData.getJSONObject("sys").getString("country");
            request.setAttribute("cityName", cityName);
            request.setAttribute("country", country);
            
            // Main weather data
            JSONObject main = weatherData.getJSONObject("main");
            double temperature = main.getDouble("temp");
            double feelsLike = main.getDouble("feels_like");
            int humidity = main.getInt("humidity");
            
            request.setAttribute("temperature", Math.round(temperature));
            request.setAttribute("feelsLike", Math.round(feelsLike));
            request.setAttribute("humidity", humidity);
            
            // Weather description and condition
            JSONArray weatherArray = weatherData.getJSONArray("weather");
            JSONObject weather = weatherArray.getJSONObject(0);
            String description = weather.getString("description");
            String mainCondition = weather.getString("main");
            String icon = weather.getString("icon");
            
            request.setAttribute("description", capitalizeWords(description));
            request.setAttribute("weatherCondition", mainCondition.toLowerCase());
            request.setAttribute("weatherIcon", icon);
            
            // Wind data
            if (weatherData.has("wind")) {
                JSONObject wind = weatherData.getJSONObject("wind");
                double windSpeed = wind.getDouble("speed") * 3.6; // Convert m/s to km/h
                request.setAttribute("windSpeed", Math.round(windSpeed));
            }
            
            // Sunrise and sunset
            JSONObject sys = weatherData.getJSONObject("sys");
            long sunriseTimestamp = sys.getLong("sunrise") * 1000L;
            long sunsetTimestamp = sys.getLong("sunset") * 1000L;
            
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            request.setAttribute("sunrise", timeFormat.format(new Date(sunriseTimestamp)));
            request.setAttribute("sunset", timeFormat.format(new Date(sunsetTimestamp)));
            
            // Generate personalized advice
            String advice = generateWeatherAdvice(mainCondition, temperature, humidity);
            request.setAttribute("weatherAdvice", advice);
            
        } catch (Exception e) {
            throw new RuntimeException("Error parsing weather data: " + e.getMessage());
        }
    }
    
    /**
     * Parses 5-day forecast data and sets request attributes
     */
    private void parseForecastData(JSONObject forecastData, HttpServletRequest request) {
        try {
            JSONArray forecastList = forecastData.getJSONArray("list");
            List<JSONObject> dailyForecasts = new ArrayList<>();
            
            SimpleDateFormat dayFormat = new SimpleDateFormat("EEE, MMM dd");
            String currentDate = "";
            
            // Process forecast data (API returns 3-hour intervals, we want daily data)
            for (int i = 0; i < forecastList.length(); i++) {
                JSONObject forecast = forecastList.getJSONObject(i);
                long timestamp = forecast.getLong("dt") * 1000L;
                String forecastDate = dayFormat.format(new Date(timestamp));
                
                // Skip today's data and process next 5 days
                if (!forecastDate.equals(currentDate) && dailyForecasts.size() < 5) {
                    JSONObject main = forecast.getJSONObject("main");
                    JSONObject weather = forecast.getJSONArray("weather").getJSONObject(0);
                    
                    JSONObject dailyForecast = new JSONObject();
                    dailyForecast.put("date", forecastDate);
                    dailyForecast.put("tempMax", Math.round(main.getDouble("temp_max")));
                    dailyForecast.put("tempMin", Math.round(main.getDouble("temp_min")));
                    dailyForecast.put("description", capitalizeWords(weather.getString("description")));
                    dailyForecast.put("icon", weather.getString("icon"));
                    
                    dailyForecasts.add(dailyForecast);
                    currentDate = forecastDate;
                }
            }
            
            request.setAttribute("forecastList", dailyForecasts);
            
        } catch (Exception e) {
            // If forecast parsing fails, set empty list
            request.setAttribute("forecastList", new ArrayList<JSONObject>());
        }
    }
    
    /**
     * Generates personalized weather advice based on conditions
     */
    private String generateWeatherAdvice(String condition, double temperature, int humidity) {
        switch (condition.toLowerCase()) {
            case "rain":
            case "drizzle":
                return "☔ Don't forget your umbrella today!";
            case "snow":
                return "❄️ Bundle up and stay warm! Watch out for slippery roads.";
            case "clear":
                if (temperature > 25) {
                    return "☀️ Perfect weather! Don't forget sunscreen and stay hydrated.";
                } else {
                    return "🌞 Beautiful clear skies! It's a great day to be outside.";
                }
            case "clouds":
                return "☁️ Cloudy but comfortable weather. Great for outdoor activities!";
            case "thunderstorm":
                return "⛈️ Thunderstorms expected. Stay indoors and stay safe!";
            case "mist":
            case "fog":
                return "🌫️ Reduced visibility due to fog. Drive carefully!";
            default:
                if (humidity > 80) {
                    return "💧 High humidity today. Stay cool and hydrated!";
                } else if (temperature < 0) {
                    return "🧊 Freezing temperatures! Dress warmly and be careful of ice.";
                } else {
                    return "🌤️ Have a wonderful day and enjoy the weather!";
                }
        }
    }
    
    /**
     * Capitalizes the first letter of each word in a string
     */
    private String capitalizeWords(String str) {
        String[] words = str.split(" ");
        StringBuilder capitalized = new StringBuilder();
        
        for (String word : words) {
            if (word.length() > 0) {
                capitalized.append(Character.toUpperCase(word.charAt(0)))
                          .append(word.substring(1).toLowerCase())
                          .append(" ");
            }
        }
        
        return capitalized.toString().trim();
    }
    
    /**
     * Converts exception to user-friendly error message
     */
    private String getErrorMessage(Exception e) {
        String message = e.getMessage();
        
        if (message != null && message.contains("CITY_NOT_FOUND")) {
            return "City not found. Please check the spelling and try again.";
        } else if (e instanceof java.net.SocketTimeoutException) {
            return "Request timed out. Please check your internet connection and try again.";
        } else if (e instanceof java.net.ConnectException) {
            return "Unable to connect to weather service. Please try again later.";
        } else if (message != null && message.contains("API request failed")) {
            return "Weather service is temporarily unavailable. Please try again later.";
        } else {
            return "An unexpected error occurred. Please try again.";
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to the main page
        response.sendRedirect("index.jsp");
    }
}
