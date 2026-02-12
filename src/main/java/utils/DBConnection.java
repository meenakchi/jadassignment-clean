package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/silver_care?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
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
        String dbUrl = System.getenv("MYSQL_URL");

        if (dbUrl != null && !dbUrl.isEmpty()) {
            System.out.println("📡 Railway MySQL URL detected");
            
            // Fix the protocol
            if (dbUrl.startsWith("mysql://")) {
                dbUrl = "jdbc:" + dbUrl;
            }
            
            // CRITICAL FIX for Railway MySQL
            // Remove any existing query parameters and add the correct ones
            if (dbUrl.contains("?")) {
                dbUrl = dbUrl.substring(0, dbUrl.indexOf("?"));
            }
            
            // Railway MySQL requires these specific parameters
            dbUrl += "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true";
            
            System.out.println("🔌 Connecting to Railway MySQL...");
            System.out.println("   Host: " + (dbUrl.contains("@") ? dbUrl.substring(dbUrl.indexOf("@") + 1).split("/")[0] : "unknown"));
            
            try {
                Connection conn = DriverManager.getConnection(dbUrl);
                System.out.println("✅ Railway MySQL connection successful!");
                return conn;
            } catch (SQLException e) {
                System.err.println("❌ Railway MySQL connection failed!");
                System.err.println("   Error: " + e.getMessage());
                throw e;
            }
        }

        System.out.println("🏠 Using local MySQL");
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }
}