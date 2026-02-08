
package dao;

import model.EmergencyContact;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmergencyContactDAO {
    
    public List getContactsByMember(int memberId) throws SQLException {
        List contacts = new ArrayList<>();
        String sql = "SELECT * FROM emergency_contacts WHERE member_id = ? ORDER BY is_primary DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    EmergencyContact contact = new EmergencyContact();
                    contact.setContactId(rs.getInt("contact_id"));
                    contact.setMemberId(rs.getInt("member_id"));
                    contact.setContactName(rs.getString("contact_name"));
                    contact.setRelationship(rs.getString("relationship"));
                    contact.setPhone(rs.getString("phone"));
                    contact.setEmail(rs.getString("email"));
                    contact.setAddress(rs.getString("address"));
                    contact.setPrimary(rs.getBoolean("is_primary"));
                    contact.setCreatedAt(rs.getTimestamp("created_at"));
                    contacts.add(contact);
                }
            }
        }
        return contacts;
    }
    
    public boolean addContact(EmergencyContact contact) throws SQLException {
        String sql = "INSERT INTO emergency_contacts " +
                    "(member_id, contact_name, relationship, phone, email, address, is_primary) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, contact.getMemberId());
            pstmt.setString(2, contact.getContactName());
            pstmt.setString(3, contact.getRelationship());
            pstmt.setString(4, contact.getPhone());
            pstmt.setString(5, contact.getEmail());
            pstmt.setString(6, contact.getAddress());
            pstmt.setBoolean(7, contact.isPrimary());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteContact(int contactId) throws SQLException {
        String sql = "DELETE FROM emergency_contacts WHERE contact_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, contactId);
            return pstmt.executeUpdate() > 0;
        }
    }
}