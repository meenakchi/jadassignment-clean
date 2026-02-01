<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%
    // SESSION MANAGEMENT - Check if user is logged in
    Integer memberId = (Integer) session.getAttribute("member_id");
    if(memberId == null) {
        response.sendRedirect("Loginmember.jsp");
        return;
    }

    String message = "";
    String messageType = ""; // success or error
    
    if(request.getMethod().equalsIgnoreCase("POST")) {
        // Get form data
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String dob = request.getParameter("dob");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            String sql = "UPDATE members SET full_name=?, email=?, phone=?, address=?, date_of_birth=? WHERE member_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName);
            pstmt.setString(2, email);
            pstmt.setString(3, phone);
            pstmt.setString(4, address);
            
            // Handle date - can be empty
            if(dob != null && !dob.trim().isEmpty()) {
                pstmt.setDate(5, java.sql.Date.valueOf(dob));
            } else {
                pstmt.setNull(5, java.sql.Types.DATE);
            }
            
            pstmt.setInt(6, memberId);
            
            int rowsUpdated = pstmt.executeUpdate();
            
            if(rowsUpdated > 0) {
                message = "Profile updated successfully!";
                messageType = "success";
            } else {
                message = "Failed to update profile. Please try again.";
                messageType = "error";
            }
            
        } catch(Exception e) {
            message = "Error updating profile: " + e.getMessage();
            messageType = "error";
            e.printStackTrace();
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>

<%@ include file="includes/header.jsp" %>

<style>
    .message-container {
        max-width: 600px;
        margin: 50px auto;
        padding: 30px;
        text-align: center;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .success-icon, .error-icon {
        font-size: 60px;
        margin-bottom: 20px;
    }
    .success-message {
        color: #27ae60;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .error-message {
        color: #e74c3c;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .message-text {
        color: #555;
        font-size: 16px;
        margin-bottom: 30px;
    }
    .back-btn {
        display: inline-block;
        padding: 12px 30px;
        background-color: #3498db;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        transition: background-color 0.3s;
    }
    .back-btn:hover {
        background-color: #2980b9;
    }
</style>

<div class="message-container">
    <% if(messageType.equals("success")) { %>
        <div class="success-icon">✓</div>
        <div class="success-message">Success!</div>
    <% } else { %>
        <div class="error-icon">✗</div>
        <div class="error-message">Update Failed</div>
    <% } %>
    
    <p class="message-text"><%= message %></p>
    <a href="memberDashboard.jsp" class="back-btn">Back to Dashboard</a>
</div>

<%@ include file="includes/footer.jsp" %>