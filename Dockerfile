# Step 1: Build the Java code
FROM maven:3.8.4-openjdk-11-slim AS build
COPY . /app
WORKDIR /app
# This compiles your code and packages it
RUN mvn clean package || mkdir -p target/classes && javac -d target/classes $(find src -name "*.java")

# Step 2: Run Tomcat
FROM tomcat:9.0-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the JSPs
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT/

# Copy the compiled Classes into the correct Tomcat folder
COPY --from=build /app/target/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Port fix
CMD sed -i "s/8080/$PORT/g" /usr/local/tomcat/conf/server.xml && catalina.sh run