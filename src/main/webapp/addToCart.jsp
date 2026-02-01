<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.regex.Pattern" %>
<%
    // 1. Session Check
    Integer memberId = (Integer) session.getAttribute("member_id");
    if (memberId == null) {
        response.sendRedirect("Loginmember.jsp");
        return;
    }

    String serviceIdStr = request.getParameter("service_id");

    // 2. Input Validation (Crucial Security Fix)
    // Check if the parameter is missing or does not contain only digits.
    if (serviceIdStr == null || !Pattern.matches("\\d+", serviceIdStr)) {
        out.println("Invalid or missing service ID!");
        return;
    }

    // Convert the validated string to an integer
    int serviceId;
    try {
        serviceId = Integer.parseInt(serviceIdStr);
    } catch (NumberFormatException e) {
        // This should not happen due to the regex check, but it's good defensive programming.
        out.println("Error processing service ID format.");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // Transaction start (Optional but recommended for consistency)
        conn.setAutoCommit(false); 

        // Check if the service already exists in the cart to get the current quantity
        String checkQuery = "SELECT quantity FROM cart WHERE member_id=? AND service_id=?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setInt(1, memberId);
        pstmt.setInt(2, serviceId); // Using the validated integer
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Already in cart → update quantity
            int newQty = rs.getInt("quantity") + 1;
            String updateQuery = "UPDATE cart SET quantity=? WHERE member_id=? AND service_id=?";
            pstmt.close(); // Close previous statement
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setInt(1, newQty);
            pstmt.setInt(2, memberId);
            pstmt.setInt(3, serviceId);
            pstmt.executeUpdate();
        } else {
            // Insert new cart item
            String insertQuery = "INSERT INTO cart (member_id, service_id, quantity) VALUES (?, ?, 1)";
            pstmt.close(); // Close previous statement
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, serviceId);
            pstmt.executeUpdate();
        }
        
        // Commit the transaction
        conn.commit(); 

        response.sendRedirect("memberDashboard.jsp?added=1");

    } catch (SQLException e) {
        // Rollback the transaction on failure
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                // Log or handle rollback failure
            }
        }
        // Log the error for administrators, and display a user-friendly message.
        System.err.println("SQL Error during cart operation: " + e.getMessage());
        out.println("A database error occurred. Please try again.");
    } catch (Exception e) {
        System.err.println("Unexpected Error: " + e.getMessage());
        out.println("An unexpected error occurred.");
    } finally {
        // 3. Resource Cleanup (Crucial Best Practice)
        if (rs != null) { try { rs.close(); } catch (SQLException ignore) {} }
        if (pstmt != null) { try { pstmt.close(); } catch (SQLException ignore) {} }
        if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignore) {} }
    }
%>