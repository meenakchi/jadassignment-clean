# Step 1: Build Stage
FROM openjdk:11-slim AS build
WORKDIR /app
COPY . .

# We need the Servlet API to compile. 
# We'll download it temporarily just to pass the 'javac' check.
RUN apt-get update && apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar -O servlet-api.jar

# Now we compile with the -cp (classpath) flag pointing to that JAR
RUN mkdir -p target/classes && \
    javac -cp "servlet-api.jar" -d target/classes $(find src/main/java -name "*.java")

# Step 2: Runtime Stage
FROM tomcat:10.1-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSPs and static files
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT/

# Copy your compiled classes from the build stage
COPY --from=build /app/target/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Port fix for Render/Railway
CMD sed -i "s/8080/$PORT/g" /usr/local/tomcat/conf/server.xml && catalina.sh run