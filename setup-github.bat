@echo off
REM AuraWeather GitHub Setup Script for Windows

echo 🌤️ Setting up AuraWeather for GitHub deployment...

REM Check if git is initialized
if not exist ".git" (
    echo 📋 Initializing Git repository...
    git init
    git branch -M main
)

REM Add all files to git
echo 📦 Adding files to Git...
git add .

REM Create initial commit
echo 💾 Creating initial commit...
git commit -m "feat: initial commit - AuraWeather application" -m "✨ Features:" -m "- Dynamic weather-aware UI with background changes" -m "- Comprehensive weather data display" -m "- 5-day forecast with detailed information" -m "- Smart weather advice system" -m "- Fully responsive design" -m "- Modern UI with smooth animations" -m "- Error handling and user-friendly messages" -m "" -m "🛠️ Tech Stack:" -m "- Java Servlets & JSP" -m "- OpenWeatherMap API integration" -m "- Maven build system" -m "- Responsive CSS with Flexbox/Grid" -m "- Font Awesome icons" -m "- Google Fonts (Poppins)" -m "" -m "📱 Responsive design optimized for all devices" -m "🌐 Production-ready with security best practices"

echo.
echo ✅ Git repository is ready!
echo.
echo 🚀 Next steps:
echo 1. Create a new repository on GitHub
echo 2. Copy the remote URL and run:
echo    git remote add origin ^<your-github-repo-url^>
echo    git push -u origin main
echo.
echo 3. For deployment, check DEPLOYMENT.md for options:
echo    - Render.com (Recommended for free hosting)
echo    - Railway
echo    - Heroku
echo    - AWS/Google Cloud/Azure
echo.
echo ⚠️  Remember: GitHub Pages won't work for this Java application!
echo    It only supports static HTML/CSS/JS files.
echo.
echo 🔑 Don't forget to set your API key as environment variable:
echo    OPENWEATHER_API_KEY=your_actual_api_key_here
echo.
echo 📖 Read README.md for detailed setup instructions
echo 🌟 Star the repository if you find it helpful!

pause
