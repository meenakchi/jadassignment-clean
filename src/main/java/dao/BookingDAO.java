package dao;

import model.Booking;
import model.BookingDetail;
import utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BookingDAO - Data Access Object for Booking operations
 */
public class BookingDAO {

    /**
     * Create new booking with details (transaction)
     */
    public int createBooking(Booking booking, List<BookingDetail> details) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int bookingId = 0;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert booking
            String bookingSql = "INSERT INTO bookings (member_id, booking_date, booking_time, " +
                              "total_amount, status, special_requests) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, booking.getMemberId());
            pstmt.setDate(2, booking.getBookingDate());
            pstmt.setTime(3, booking.getBookingTime());
            pstmt.setBigDecimal(4, booking.getTotalAmount());
            pstmt.setString(5, booking.getStatus());
            pstmt.setString(6, booking.getSpecialRequests());
            
            pstmt.executeUpdate();
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);
            }
            
            rs.close();
            pstmt.close();
            
            // Insert booking details
            String detailSql = "INSERT INTO booking_details (booking_id, service_id, quantity, subtotal) " +
                             "VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(detailSql);
            
            for (BookingDetail detail : details) {
                pstmt.setInt(1, bookingId);
                pstmt.setInt(2, detail.getServiceId());
                pstmt.setInt(3, detail.getQuantity());
                pstmt.setBigDecimal(4, detail.getSubtotal());
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            conn.commit(); // Commit transaction
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Rollback on error
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        return bookingId;
    }

    /**
     * Get booking by ID
     */
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT b.*, m.full_name as member_name, m.email as member_email " +
                    "FROM bookings b " +
                    "JOIN members m ON b.member_id = m.member_id " +
                    "WHERE b.booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractBookingFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Get all bookings (for admin)
     */
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, m.full_name as member_name, m.email as member_email " +
                    "FROM bookings b " +
                    "JOIN members m ON b.member_id = m.member_id " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        }
        return bookings;
    }

    /**
     * Get bookings by member ID
     */
    public List<Booking> getBookingsByMemberId(int memberId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, m.full_name as member_name, m.email as member_email " +
                    "FROM bookings b " +
                    "JOIN members m ON b.member_id = m.member_id " +
                    "WHERE b.member_id = ? " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return bookings;
    }

    /**
     * Get booking details
     */
    public List<BookingDetail> getBookingDetails(int bookingId) throws SQLException {
        List<BookingDetail> details = new ArrayList<>();
        String sql = "SELECT bd.*, s.service_name, s.price as service_price " +
                    "FROM booking_details bd " +
                    "JOIN service s ON bd.service_id = s.service_id " +
                    "WHERE bd.booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    BookingDetail detail = new BookingDetail();
                    detail.setBookingDetailId(rs.getInt("booking_detail_id"));
                    detail.setBookingId(rs.getInt("booking_id"));
                    detail.setServiceId(rs.getInt("service_id"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setSubtotal(rs.getBigDecimal("subtotal"));
                    detail.setServiceName(rs.getString("service_name"));
                    detail.setServicePrice(rs.getBigDecimal("service_price"));
                    details.add(detail);
                }
            }
        }
        return details;
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, bookingId);
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get bookings by date range
     */
    public List<Booking> getBookingsByDateRange(Date startDate, Date endDate) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, m.full_name as member_name, m.email as member_email " +
                    "FROM bookings b " +
                    "JOIN members m ON b.member_id = m.member_id " +
                    "WHERE b.booking_date BETWEEN ? AND ? " +
                    "ORDER BY b.booking_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(extractBookingFromResultSet(rs));
                }
            }
        }
        return bookings;
    }

    /**
     * Get revenue by date range
     */
    public BigDecimal getRevenue(Date startDate, Date endDate) throws SQLException {
        String sql = "SELECT SUM(total_amount) as revenue " +
                    "FROM bookings " +
                    "WHERE booking_date BETWEEN ? AND ? " +
                    "AND status IN ('CONFIRMED', 'COMPLETED')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, startDate);
            pstmt.setDate(2, endDate);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal("revenue");
                    return revenue != null ? revenue : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Delete booking
     */
    public boolean deleteBooking(int bookingId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Delete booking details first
            String detailSql = "DELETE FROM booking_details WHERE booking_id = ?";
            pstmt = conn.prepareStatement(detailSql);
            pstmt.setInt(1, bookingId);
            pstmt.executeUpdate();
            pstmt.close();
            
            // Delete booking
            String bookingSql = "DELETE FROM bookings WHERE booking_id = ?";
            pstmt = conn.prepareStatement(bookingSql);
            pstmt.setInt(1, bookingId);
            int result = pstmt.executeUpdate();
            
            conn.commit();
            return result > 0;
            
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Helper method to extract Booking from ResultSet
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setMemberId(rs.getInt("member_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingTime(rs.getTime("booking_time"));
        booking.setTotalAmount(rs.getBigDecimal("total_amount"));
        booking.setStatus(rs.getString("status"));
        booking.setSpecialRequests(rs.getString("special_requests"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setMemberName(rs.getString("member_name"));
        booking.setMemberEmail(rs.getString("member_email"));
        return booking;
    }
}