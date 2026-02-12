package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // 1. Local Fallbacks (Used when running on your own computer)
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/silver_care?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "root1234";

    static {
        try {
            // Load the driver once when the class is initialized
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found! Make sure the JAR is in your project.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        // 2. Look for the 'sticky note' (Environment Variable) from Render
        String dbUrl = System.getenv("MYSQL_URL");

        // 3. If the variable exists, we are running on Render
        if (dbUrl != null && !dbUrl.isEmpty()) {
            
            // Format correction: Railway gives 'mysql://', Java needs 'jdbc:mysql://'
            if (dbUrl.startsWith("mysql://")) {
                dbUrl = "jdbc:" + dbUrl;
            }
            
            // Security Fix: Allow the handshake and disable SSL to prevent EOF/Link failure
            if (!dbUrl.contains("?")) {
                dbUrl += "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
            }
            
            System.out.println("Connecting to Cloud Database...");
            return DriverManager.getConnection(dbUrl);
        }

        // 4. If no environment variable is found, use your local laptop settings
        System.out.println("Connecting to Local Database...");
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }
}