# Use OpenJDK 11 as base image
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy source code
COPY . .

# Build the application
RUN mvn clean package

# Expose port
EXPOSE $PORT

# Start command
CMD ["java", "-Dserver.port=$PORT", "-jar", "target/dependency/webapp-runner.jar", "--port", "$PORT", "target/auraweather.war"]
