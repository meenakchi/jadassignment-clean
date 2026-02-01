package dao;

import model.Feedback;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FeedbackDAO - Data Access Object for Feedback operations
 */
public class FeedbackDAO {

    /**
     * Add new feedback
     */
    public boolean addFeedback(Feedback feedback) throws SQLException {
        String sql = "INSERT INTO feedback (member_id, booking_id, service_id, rating, comments) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, feedback.getMemberId());
            pstmt.setInt(2, feedback.getBookingId());
            pstmt.setInt(3, feedback.getServiceId());
            pstmt.setInt(4, feedback.getRating());
            pstmt.setString(5, feedback.getComments());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        feedback.setFeedbackId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Get all feedback
     */
    public List<Feedback> getAllFeedback() throws SQLException {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.*, m.full_name as member_name, s.service_name " +
                    "FROM feedback f " +
                    "JOIN members m ON f.member_id = m.member_id " +
                    "JOIN service s ON f.service_id = s.service_id " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Feedback feedback = extractFeedbackFromResultSet(rs);
                feedback.setMemberName(rs.getString("member_name"));
                feedback.setServiceName(rs.getString("service_name"));
                feedbackList.add(feedback);
            }
        }
        return feedbackList;
    }

    /**
     * Get feedback by service ID
     */
    public List<Feedback> getFeedbackByServiceId(int serviceId) throws SQLException {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.*, m.full_name as member_name, s.service_name " +
                    "FROM feedback f " +
                    "JOIN members m ON f.member_id = m.member_id " +
                    "JOIN service s ON f.service_id = s.service_id " +
                    "WHERE f.service_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = extractFeedbackFromResultSet(rs);
                    feedback.setMemberName(rs.getString("member_name"));
                    feedback.setServiceName(rs.getString("service_name"));
                    feedbackList.add(feedback);
                }
            }
        }
        return feedbackList;
    }

    /**
     * Get feedback by member ID
     */
    public List<Feedback> getFeedbackByMemberId(int memberId) throws SQLException {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.*, m.full_name as member_name, s.service_name " +
                    "FROM feedback f " +
                    "JOIN members m ON f.member_id = m.member_id " +
                    "JOIN service s ON f.service_id = s.service_id " +
                    "WHERE f.member_id = ? " +
                    "ORDER BY f.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = extractFeedbackFromResultSet(rs);
                    feedback.setMemberName(rs.getString("member_name"));
                    feedback.setServiceName(rs.getString("service_name"));
                    feedbackList.add(feedback);
                }
            }
        }
        return feedbackList;
    }

    /**
     * Get average rating for a service
     */
    public double getAverageRating(int serviceId) throws SQLException {
        String sql = "SELECT AVG(rating) as avg_rating FROM feedback WHERE service_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        }
        return 0.0;
    }

    /**
     * Delete feedback
     */
    public boolean deleteFeedback(int feedbackId) throws SQLException {
        String sql = "DELETE FROM feedback WHERE feedback_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, feedbackId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Helper method to extract Feedback from ResultSet
     */
    private Feedback extractFeedbackFromResultSet(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(rs.getInt("feedback_id"));
        feedback.setMemberId(rs.getInt("member_id"));
        feedback.setBookingId(rs.getInt("booking_id"));
        feedback.setServiceId(rs.getInt("service_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComments(rs.getString("comments"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        return feedback;
    }
}