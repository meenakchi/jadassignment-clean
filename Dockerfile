# Step 1: Build Stage
# Changed from openjdk:11-slim to eclipse-temurin:11-jdk-focal
FROM eclipse-temurin:11-jdk-focal AS build
WORKDIR /app
COPY . .

# Download the Servlet API so the compiler knows what 'jakarta' is
RUN apt-get update && apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar -O servlet-api.jar

# Compile the code
RUN mkdir -p target/classes && \
    javac -cp "servlet-api.jar" -d target/classes $(find src/main/java -name "*.java")

# Step 2: Runtime Stage (Tomcat)
FROM tomcat:10.1-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSPs and static files
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT/

# Copy your compiled classes
COPY --from=build /app/target/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Fix the port for Render
CMD sed -i "s/8080/$PORT/g" /usr/local/tomcat/conf/server.xml && catalina.sh run