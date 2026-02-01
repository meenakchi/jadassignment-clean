package dao;

import model.CartItem;
import utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CartDAO - Data Access Object for Shopping Cart operations
 */
public class CartDAO {

    /**
     * Get all cart items for a member
     */
    public List<CartItem> getCartItemsByMemberId(int memberId) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.cart_id, c.member_id, c.service_id, c.quantity, " +
                    "s.service_name, s.price, s.image_url, s.duration " +
                    "FROM cart c " +
                    "JOIN service s ON c.service_id = s.service_id " +
                    "WHERE c.member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setMemberId(rs.getInt("member_id"));
                    item.setServiceId(rs.getInt("service_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setServiceName(rs.getString("service_name"));
                    item.setServicePrice(rs.getBigDecimal("price"));
                    item.setImageUrl(rs.getString("image_url"));
                    item.setDuration(rs.getInt("duration"));
                    cartItems.add(item);
                }
            }
        }
        return cartItems;
    }

    /**
     * Add item to cart
     */
    public boolean addToCart(int memberId, int serviceId, int quantity) throws SQLException {
        // Check if item already exists
        String checkSql = "SELECT quantity FROM cart WHERE member_id=? AND service_id=?";
        
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, memberId);
                checkStmt.setInt(2, serviceId);
                
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        // Update existing quantity
                        int newQty = rs.getInt("quantity") + quantity;
                        String updateSql = "UPDATE cart SET quantity=? WHERE member_id=? AND service_id=?";
                        
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, newQty);
                            updateStmt.setInt(2, memberId);
                            updateStmt.setInt(3, serviceId);
                            return updateStmt.executeUpdate() > 0;
                        }
                    } else {
                        // Insert new item
                        String insertSql = "INSERT INTO cart (member_id, service_id, quantity) VALUES (?, ?, ?)";
                        
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, memberId);
                            insertStmt.setInt(2, serviceId);
                            insertStmt.setInt(3, quantity);
                            return insertStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        }
    }

    /**
     * Update cart item quantity
     */
    public boolean updateCartQuantity(int cartId, int quantity) throws SQLException {
        String sql = "UPDATE cart SET quantity=? WHERE cart_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove item from cart
     */
    public boolean removeFromCart(int cartId) throws SQLException {
        String sql = "DELETE FROM cart WHERE cart_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Clear all cart items for a member
     */
    public boolean clearCart(int memberId) throws SQLException {
        String sql = "DELETE FROM cart WHERE member_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get cart total amount
     */
    public BigDecimal getCartTotal(int memberId) throws SQLException {
        String sql = "SELECT SUM(c.quantity * s.price) as total " +
                    "FROM cart c JOIN service s ON c.service_id = s.service_id " +
                    "WHERE c.member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal("total");
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Get cart item count
     */
    public int getCartItemCount(int memberId) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM cart WHERE member_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}