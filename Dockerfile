# Multi-stage build for Java Maven application
FROM maven:3.8.6-openjdk-11 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first (for better caching)
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Production stage
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the built WAR file and webapp-runner from build stage
COPY --from=build /app/target/*.war /app/app.war
COPY --from=build /app/target/dependency/webapp-runner.jar /app/webapp-runner.jar

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# Expose the port
EXPOSE $PORT

# Start the application
CMD ["sh", "-c", "java -Dserver.port=$PORT -jar webapp-runner.jar --port $PORT app.war"]
