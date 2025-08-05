# Simple single-stage build
FROM openjdk:11

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && apt-get clean

# Copy project files
COPY . .

# Build the project
RUN mvn clean package -DskipTests

# Expose port
EXPOSE 8080

# Start the application
CMD java -jar target/dependency/webapp-runner.jar --port ${PORT:-8080} target/*.war
