package dao;

import model.Admin;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminDAO - Data Access Object for Admin operations
 */
public class AdminDAO {

    /**
     * Authenticate admin login
     */
    public Admin validateLogin(String username, String password) throws SQLException {
        String sql = "SELECT * FROM admin WHERE username=? AND password=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractAdminFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Get admin by ID
     */
    public Admin getAdminById(int adminId) throws SQLException {
        String sql = "SELECT * FROM admin WHERE admin_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractAdminFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Add new admin
     */
    public boolean addAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO admin (username, password, email, full_name) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, admin.getUsername());
            pstmt.setString(2, admin.getPassword());
            pstmt.setString(3, admin.getEmail());
            pstmt.setString(4, admin.getFullName());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        admin.setAdminId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Update admin
     */
    public boolean updateAdmin(Admin admin) throws SQLException {
        String sql = "UPDATE admin SET full_name=?, email=? WHERE admin_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getFullName());
            pstmt.setString(2, admin.getEmail());
            pstmt.setInt(3, admin.getAdminId());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Update admin with password
     */
    public boolean updateAdminWithPassword(Admin admin) throws SQLException {
        String sql = "UPDATE admin SET full_name=?, email=?, password=? WHERE admin_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getFullName());
            pstmt.setString(2, admin.getEmail());
            pstmt.setString(3, admin.getPassword());
            pstmt.setInt(4, admin.getAdminId());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete admin
     */
    public boolean deleteAdmin(int adminId) throws SQLException {
        String sql = "DELETE FROM admin WHERE admin_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get all admins
     */
    public List<Admin> getAllAdmins() throws SQLException {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM admin ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                admins.add(extractAdminFromResultSet(rs));
            }
        }
        return admins;
    }

    /**
     * Check if username exists
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin WHERE username=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Helper method to extract Admin from ResultSet
     */
    private Admin extractAdminFromResultSet(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setEmail(rs.getString("email"));
        admin.setFullName(rs.getString("full_name"));
        admin.setCreatedAt(rs.getTimestamp("created_at"));
        return admin;
    }
}