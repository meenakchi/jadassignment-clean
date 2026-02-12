# Step 1: Build Stage
FROM eclipse-temurin:11-jdk-focal AS build
WORKDIR /app
COPY . .

# Download ALL the missing libraries (Servlet, Gson, and Stripe)
RUN apt-get update && apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/5.0.0/jakarta.servlet-api-5.0.0.jar -O servlet-api.jar && \
    wget https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar -O gson.jar && \
    wget https://repo1.maven.org/maven2/com/stripe/stripe-java/22.31.0/stripe-java-22.31.0.jar -O stripe.jar

# Compile using ALL JARs in the classpath (separated by colons)
RUN mkdir -p target/classes && \
    javac -cp "servlet-api.jar:gson.jar:stripe.jar" -d target/classes $(find src/main/java -name "*.java")

# Step 2: Runtime Stage (Tomcat)
FROM tomcat:10.1-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy JSPs
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT/

# Copy the compiled classes
COPY --from=build /app/target/classes /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# IMPORTANT: We must also copy the JARs we downloaded into WEB-INF/lib 
# so the app can find them when it's actually running!
COPY --from=build /app/gson.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/
COPY --from=build /app/stripe.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Port fix for Render
CMD sed -i "s/8080/$PORT/g" /usr/local/tomcat/conf/server.xml && catalina.sh run