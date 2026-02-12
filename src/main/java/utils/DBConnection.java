package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // These remain as fallbacks for your local machine
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/silver_care?useSSL=false&serverTimezone=UTC";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "root1234";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        // 1. Try to get the Railway URL from Render's Environment Variables
        String dbUrl = System.getenv("MYSQL_URL");

        // 2. If the variable exists (we are on Render)
        if (dbUrl != null && !dbUrl.isEmpty()) {
            // Convert 'mysql://' to 'jdbc:mysql://' if necessary
            if (dbUrl.startsWith("mysql://")) {
                dbUrl = "jdbc:" + dbUrl;
            }
            return DriverManager.getConnection(dbUrl);
        }

        // 3. If no environment variable is found (we are on your laptop)
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }
}