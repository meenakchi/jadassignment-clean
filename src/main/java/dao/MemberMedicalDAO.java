
package dao;

import model.MemberMedicalInfo;
import utils.DBConnection;
import java.sql.*;

public class MemberMedicalDAO {
    
    public MemberMedicalInfo getMedicalInfo(int memberId) throws SQLException {
        String sql = "SELECT * FROM member_medical_info WHERE member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, memberId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MemberMedicalInfo info = new MemberMedicalInfo();
                    info.setMedicalInfoId(rs.getInt("medical_info_id"));
                    info.setMemberId(rs.getInt("member_id"));
                    info.setBloodType(rs.getString("blood_type"));
                    info.setAllergies(rs.getString("allergies"));
                    info.setMedications(rs.getString("medications"));
                    info.setMedicalConditions(rs.getString("medical_conditions"));
                    info.setMobilityStatus(rs.getString("mobility_status"));
                    info.setDietaryRestrictions(rs.getString("dietary_restrictions"));
                    info.setLastUpdated(rs.getTimestamp("last_updated"));
                    return info;
                }
            }
        }
        return null;
    }
    
    public boolean saveMedicalInfo(MemberMedicalInfo info) throws SQLException {
        String sql = "INSERT INTO member_medical_info " +
                    "(member_id, blood_type, allergies, medications, medical_conditions, " +
                    "mobility_status, dietary_restrictions) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE " +
                    "blood_type=VALUES(blood_type), allergies=VALUES(allergies), " +
                    "medications=VALUES(medications), medical_conditions=VALUES(medical_conditions), " +
                    "mobility_status=VALUES(mobility_status), dietary_restrictions=VALUES(dietary_restrictions)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, info.getMemberId());
            pstmt.setString(2, info.getBloodType());
            pstmt.setString(3, info.getAllergies());
            pstmt.setString(4, info.getMedications());
            pstmt.setString(5, info.getMedicalConditions());
            pstmt.setString(6, info.getMobilityStatus());
            pstmt.setString(7, info.getDietaryRestrictions());
            
            return pstmt.executeUpdate() > 0;
        }
    }
}