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
            // Fix the protocol
            if (dbUrl.startsWith("mysql://")) {
                dbUrl = "jdbc:" + dbUrl;
            }
            
            // This part is the "Cry-Stopper"
            // It fixes the EOFException by allowing the security handshake
            if (!dbUrl.contains("?")) {
                dbUrl += "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
            } else if (!dbUrl.contains("allowPublicKeyRetrieval=true")) {
                dbUrl += "&allowPublicKeyRetrieval=true&useSSL=false";
            }
            
            return DriverManager.getConnection(dbUrl);
        }

        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }
}