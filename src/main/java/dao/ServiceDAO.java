package dao;

import model.Service;
import model.ServiceCategory;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ServiceDAO - Data Access Object for Service operations
 */
public class ServiceDAO {

    /**
     * Get all active services - FIXED to show all services
     */
    public List<Service> getAllActiveServices() throws SQLException {
        List<Service> services = new ArrayList<>();
        // FIXED: Remove the is_active filter to show all services
        String sql = "SELECT s.*, sc.category_name FROM service s " +
                    "JOIN service_category sc ON s.category_id = sc.category_id " +
                    "ORDER BY sc.category_name, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                services.add(extractServiceFromResultSet(rs));
            }
        }
        
        System.out.println("getAllActiveServices: Found " + services.size() + " services");
        return services;
    }

    /**
     * Get all services (including inactive) - for admin
     */
    public List<Service> getAllServices() throws SQLException {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.category_name FROM service s " +
                    "JOIN service_category sc ON s.category_id = sc.category_id " +
                    "ORDER BY sc.category_name, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                services.add(extractServiceFromResultSet(rs));
            }
        }
        return services;
    }

    /**
     * Get services by category
     */
    public List<Service> getServicesByCategory(int categoryId) throws SQLException {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, sc.category_name FROM service s " +
                    "JOIN service_category sc ON s.category_id = sc.category_id " +
                    "WHERE s.category_id = ? " +
                    "ORDER BY s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    services.add(extractServiceFromResultSet(rs));
                }
            }
        }
        return services;
    }

    /**
     * Get service by ID
     */
    public Service getServiceById(int serviceId) throws SQLException {
        String sql = "SELECT s.*, sc.category_name FROM service s " +
                    "JOIN service_category sc ON s.category_id = sc.category_id " +
                    "WHERE s.service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractServiceFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Add new service
     */
    public boolean addService(Service service) throws SQLException {
        String sql = "INSERT INTO service (category_id, service_name, description, price, " +
                    "duration, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, service.getCategoryId());
            pstmt.setString(2, service.getServiceName());
            pstmt.setString(3, service.getDescription());
            pstmt.setBigDecimal(4, service.getPrice());
            pstmt.setInt(5, service.getDuration());
            pstmt.setString(6, service.getImageUrl());
            pstmt.setBoolean(7, service.isActive());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        service.setServiceId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Update service
     */
    public boolean updateService(Service service) throws SQLException {
        String sql = "UPDATE service SET category_id=?, service_name=?, description=?, " +
                    "price=?, duration=?, image_url=?, is_active=? WHERE service_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, service.getCategoryId());
            pstmt.setString(2, service.getServiceName());
            pstmt.setString(3, service.getDescription());
            pstmt.setBigDecimal(4, service.getPrice());
            pstmt.setInt(5, service.getDuration());
            pstmt.setString(6, service.getImageUrl());
            pstmt.setBoolean(7, service.isActive());
            pstmt.setInt(8, service.getServiceId());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete service
     */
    public boolean deleteService(int serviceId) throws SQLException {
        String sql = "DELETE FROM service WHERE service_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Toggle service active status
     */
    public boolean toggleServiceStatus(int serviceId) throws SQLException {
        String sql = "UPDATE service SET is_active = NOT is_active WHERE service_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get all categories
     */
    public List<ServiceCategory> getAllCategories() throws SQLException {
        List<ServiceCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM service_category ORDER BY category_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ServiceCategory category = new ServiceCategory();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                category.setImageUrl(rs.getString("image_url"));
                categories.add(category);
            }
        }
        return categories;
    }

    /**
     * Get service count statistics
     */
    public int getTotalServiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM service";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get active service count
     */
    public int getActiveServiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM service WHERE is_active=1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Helper method to extract Service from ResultSet
     */
    private Service extractServiceFromResultSet(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setCategoryId(rs.getInt("category_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getBigDecimal("price"));
        service.setDuration(rs.getInt("duration"));
        service.setImageUrl(rs.getString("image_url"));
        service.setActive(rs.getBoolean("is_active"));
        service.setCategoryName(rs.getString("category_name"));
        return service;
    }
}