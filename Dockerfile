# We use the official Tomcat image
FROM tomcat:9.0-jdk11-openjdk-slim

# Remove the default Tomcat webapps to keep it clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSP files from your project into Tomcat's folder
# Since your files are in src/main/webapp, we move them to ROOT
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Railway and Render both use the $PORT variable
# We tell Tomcat to listen on that specific port
CMD sed -i "s/8080/$PORT/g" /usr/local/tomcat/conf/server.xml && catalina.sh run