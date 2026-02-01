<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="checkAdminSession.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="utils.DBConnection" %>

<%
    String message = "";
    String messageType = "";
    
    // Handle DELETE action
    if("delete".equals(request.getParameter("action"))) {
        int memberId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM members WHERE member_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            
            int rows = pstmt.executeUpdate();
            if(rows > 0) {
                message = "Member deleted successfully!";
                messageType = "success";
            }
        } catch(Exception e) {
            message = "Error deleting member: " + e.getMessage();
            messageType = "error";
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
    
    // Fetch all members
    List<Map<String, Object>> members = new ArrayList<Map<String, Object>>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT * FROM members ORDER BY full_name";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> member = new HashMap<String, Object>();
            member.put("member_id", rs.getInt("member_id"));
            member.put("username", rs.getString("username"));
            member.put("full_name", rs.getString("full_name"));
            member.put("email", rs.getString("email"));
            member.put("phone", rs.getString("phone"));
            member.put("address", rs.getString("address"));
            members.add(member);
        }
    } catch(Exception e) {
        message = "Error loading members: " + e.getMessage();
        messageType = "error";
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>

<%@ include file="includes/header.jsp" %>

<style>
    .admin-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .page-header {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    .page-header h2 {
        margin: 0;
        color: #2c3e50;
    }
    .message {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        text-align: center;
    }
    .message.success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .message.error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .members-table {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    thead {
        background-color: #34495e;
        color: white;
    }
    th {
        padding: 15px;
        text-align: left;
        font-weight: 600;
    }
    td {
        padding: 15px;
        border-bottom: 1px solid #ecf0f1;
    }
    tbody tr:hover {
        background-color: #f8f9fa;
    }
    .action-btn {
        padding: 6px 12px;
        margin: 0 3px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.85rem;
        text-decoration: none;
        display: inline-block;
        transition: opacity 0.3s;
    }
    .action-btn:hover {
        opacity: 0.8;
    }
    .btn-view {
        background-color: #3498db;
        color: white;
    }
    .btn-edit {
        background-color: #f39c12;
        color: white;
    }
    .btn-delete {
        background-color: #e74c3c;
        color: white;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
    }
    .back-link:hover {
        text-decoration: underline;
    }
    .no-members {
        text-align: center;
        padding: 40px;
        color: #7f8c8d;
    }
</style>

<div class="admin-container">
    <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
    
    <div class="page-header">
        <h2>Manage Members</h2>
        <p style="color: #7f8c8d; margin: 5px 0 0 0;">View and manage registered members</p>
    </div>

    <% if(!messageType.isEmpty()) { %>
        <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="members-table">
        <% if(members.isEmpty()) { %>
            <div class="no-members">
                <h3>No members found</h3>
                <p>No registered members in the system.</p>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, Object> member : members) { %>
                        <tr>
                            <td><%= member.get("member_id") %></td>
                            <td><%= member.get("username") %></td>
                            <td><%= member.get("full_name") %></td>
                            <td><%= member.get("email") %></td>
                            <td><%= member.get("phone") != null ? member.get("phone") : "N/A" %></td>
                            <td>
                                <a href="viewMember.jsp?id=<%= member.get("member_id") %>" class="action-btn btn-view">View</a>
                                <a href="editMember.jsp?id=<%= member.get("member_id") %>" class="action-btn btn-edit">Edit</a>
                                <a href="manageMembers.jsp?action=delete&id=<%= member.get("member_id") %>" 
                                   class="action-btn btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this member?')">
                                    Delete
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>