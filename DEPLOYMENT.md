# AuraWeather Deployment Guide

This guide provides step-by-step instructions for deploying AuraWeather on various platforms.

## 🚨 Important: GitHub Pages Limitation

**GitHub Pages does NOT support Java web applications!** It only serves static HTML, CSS, and JavaScript files. Since AuraWeather is a Java Servlet/JSP application, you need a platform that supports Java applications.

## 🎯 Recommended Free Hosting Platforms

### 1. Render.com (Recommended - Free Tier)

**Why Render?**
- ✅ Free tier available
- ✅ Automatic deployments from GitHub
- ✅ Java/Tomcat support
- ✅ Custom domains
- ✅ SSL certificates

**Steps:**
1. Push your code to GitHub
2. Go to [Render.com](https://render.com) and sign up
3. Connect your GitHub account
4. Create a new "Web Service"
5. Select your repository
6. Configure build settings:
   ```
   Environment: Java
   Build Command: mvn clean package
   Start Command: java -Dserver.port=$PORT -jar target/dependency/webapp-runner.jar --port $PORT target/*.war
   ```
7. Add environment variable:
   ```
   OPENWEATHER_API_KEY=your_actual_api_key_here
   ```
8. Deploy!

### 2. Railway (Simple & Fast)

**Steps:**
1. Install Railway CLI: `npm install -g @railway/cli`
2. Login: `railway login`
3. Deploy: `railway deploy`
4. Set environment variables in Railway dashboard

### 3. Heroku (Popular Choice)

**Steps:**
1. Install Heroku CLI
2. Create `Procfile` in project root:
   ```
   web: java -Dserver.port=$PORT -jar target/dependency/webapp-runner.jar --port $PORT target/*.war
   ```
3. Deploy:
   ```bash
   heroku create your-app-name
   git push heroku main
   heroku config:set OPENWEATHER_API_KEY=your_key
   ```

## 🔧 Environment Variable Setup

For security, store your API key as an environment variable instead of hardcoding it.

### Update WeatherServlet.java

Replace the hardcoded API key:
```java
// Before (hardcoded - not secure)
private static final String API_KEY = "5408a16ffce347e29361c879d87ea99d";

// After (environment variable - secure)
private static final String API_KEY = System.getenv("OPENWEATHER_API_KEY") != null 
    ? System.getenv("OPENWEATHER_API_KEY") 
    : "5408a16ffce347e29361c879d"; // fallback for local development
```

## 📋 Pre-deployment Checklist

- [ ] API key configured as environment variable
- [ ] Application tested locally
- [ ] WAR file builds successfully (`mvn clean package`)
- [ ] No hardcoded sensitive data
- [ ] Error handling tested
- [ ] Mobile responsiveness verified
- [ ] All dependencies included in `pom.xml`

## 🌐 Alternative: Convert to Static Version

If you absolutely want to use GitHub Pages, you would need to convert the application to a pure client-side JavaScript application:

### What would need to change:
1. **Remove Java backend completely**
2. **Make API calls directly from JavaScript**
3. **Handle CORS issues** (OpenWeatherMap API supports CORS)
4. **Convert JSP files to static HTML**
5. **Implement client-side routing**

Would you like me to create a static version for GitHub Pages deployment?

## 🚀 Production Considerations

### Security
- Use HTTPS in production
- Implement rate limiting
- Validate all user inputs
- Store API keys securely

### Performance
- Enable Gzip compression
- Optimize images
- Implement caching
- Use CDN for static assets

### Monitoring
- Set up application monitoring
- Configure error logging
- Monitor API usage
- Set up uptime monitoring

## 📞 Support

If you need help with deployment, please:
1. Check the troubleshooting section in README.md
2. Open an issue on GitHub
3. Contact support team

---

**Remember**: Never commit API keys to version control!
