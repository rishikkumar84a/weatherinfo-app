#!/bin/bash

# AuraWeather GitHub Setup Script
echo "🌤️  Setting up AuraWeather for GitHub deployment..."

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📋 Initializing Git repository..."
    git init
    git branch -M main
fi

# Add all files to git
echo "📦 Adding files to Git..."
git add .

# Create initial commit
echo "💾 Creating initial commit..."
git commit -m "feat: initial commit - AuraWeather application

✨ Features:
- Dynamic weather-aware UI with background changes
- Comprehensive weather data display
- 5-day forecast with detailed information
- Smart weather advice system
- Fully responsive design
- Modern UI with smooth animations
- Error handling and user-friendly messages

🛠️ Tech Stack:
- Java Servlets & JSP
- OpenWeatherMap API integration
- Maven build system
- Responsive CSS with Flexbox/Grid
- Font Awesome icons
- Google Fonts (Poppins)

📱 Responsive design optimized for all devices
🌐 Production-ready with security best practices"

echo ""
echo "✅ Git repository is ready!"
echo ""
echo "🚀 Next steps:"
echo "1. Create a new repository on GitHub"
echo "2. Copy the remote URL and run:"
echo "   git remote add origin <your-github-repo-url>"
echo "   git push -u origin main"
echo ""
echo "3. For deployment, check DEPLOYMENT.md for options:"
echo "   - Render.com (Recommended for free hosting)"
echo "   - Railway"
echo "   - Heroku"
echo "   - AWS/Google Cloud/Azure"
echo ""
echo "⚠️  Remember: GitHub Pages won't work for this Java application!"
echo "   It only supports static HTML/CSS/JS files."
echo ""
echo "🔑 Don't forget to set your API key as environment variable:"
echo "   OPENWEATHER_API_KEY=your_actual_api_key_here"
echo ""
echo "📖 Read README.md for detailed setup instructions"
echo "🌟 Star the repository if you find it helpful!"
