<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Member" %>
<%@ include file="/includes/header.jsp" %>

<%
    // Check admin session
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect(request.getContextPath() + "/AdminLoginController");
        return;
    }
    
    List<Member> members = (List<Member>) request.getAttribute("members");
    
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

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
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="page-header">
        <h2>Manage Members</h2>
        <p style="color: #7f8c8d; margin: 5px 0 0 0;">View and manage registered members</p>
    </div>

    <% if (message != null) { %>
        <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="members-table">
        <% if (members == null || members.isEmpty()) { %>
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
                    <% for (Member member : members) { %>
                        <tr>
                            <td><%= member.getMemberId() %></td>
                            <td><%= member.getUsername() %></td>
                            <td><%= member.getFullName() %></td>
                            <td><%= member.getEmail() %></td>
                            <td><%= member.getPhone() != null ? member.getPhone() : "N/A" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/MemberDetailsController?id=<%= member.getMemberId() %>" 
                                   class="action-btn btn-view">View</a>
                                <a href="${pageContext.request.contextPath}/ManageMembersController?action=delete&id=<%= member.getMemberId() %>" 
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

<%@ include file="/includes/footer.jsp" %>
