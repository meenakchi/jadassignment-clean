package dao;

import model.Member;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * MemberDAO - Data Access Object for Member operations
 * Handles all database operations related to members
 */
public class MemberDAO {

    /**
     * Authenticate member login
     */
    public Member validateLogin(String username, String password) throws SQLException {
        String sql = "SELECT * FROM members WHERE username=? AND password=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractMemberFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Register new member
     */
    public boolean registerMember(Member member) throws SQLException {
        String sql = "INSERT INTO members (username, password, email, full_name) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, member.getUsername());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getEmail());
            pstmt.setString(4, member.getFullName());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        member.setMemberId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Check if username exists
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM members WHERE username=?";
        
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
     * Get member by ID
     */
    public Member getMemberById(int memberId) throws SQLException {
        String sql = "SELECT * FROM members WHERE member_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractMemberFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Update member profile
     */
    public boolean updateMember(Member member) throws SQLException {
        String sql = "UPDATE members SET full_name=?, email=?, phone=?, address=?, date_of_birth=? WHERE member_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, member.getFullName());
            pstmt.setString(2, member.getEmail());
            pstmt.setString(3, member.getPhone());
            pstmt.setString(4, member.getAddress());
            
            if (member.getDateOfBirth() != null) {
                pstmt.setDate(5, member.getDateOfBirth());
            } else {
                pstmt.setNull(5, Types.DATE);
            }
            
            pstmt.setInt(6, member.getMemberId());
            
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete member account
     */
    public boolean deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM members WHERE member_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get all members (for admin)
     */
    public List<Member> getAllMembers() throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                members.add(extractMemberFromResultSet(rs));
            }
        }
        return members;
    }

    /**
     * Get total member count
     */
    public int getTotalMemberCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM members";
        
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
     * Search members by name or email
     */
    public List<Member> searchMembers(String keyword) throws SQLException {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members WHERE full_name LIKE ? OR email LIKE ? ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    members.add(extractMemberFromResultSet(rs));
                }
            }
        }
        return members;
    }

    /**
     * Helper method to extract Member object from ResultSet
     */
    private Member extractMemberFromResultSet(ResultSet rs) throws SQLException {
        Member member = new Member();
        member.setMemberId(rs.getInt("member_id"));
        member.setUsername(rs.getString("username"));
        member.setPassword(rs.getString("password"));
        member.setEmail(rs.getString("email"));
        member.setFullName(rs.getString("full_name"));
        member.setPhone(rs.getString("phone"));
        member.setAddress(rs.getString("address"));
        member.setDateOfBirth(rs.getDate("date_of_birth"));
        member.setCreatedAt(rs.getTimestamp("created_at"));
        return member;
    }
}