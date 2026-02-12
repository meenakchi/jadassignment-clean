<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Member" %>
<%@ include file="/includes/header.jsp" %>

<%
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect(request.getContextPath() + "/AdminLoginController");
        return;
    }
    
    Member member = (Member) request.getAttribute("member");
    if(member == null) {
        response.sendRedirect(request.getContextPath() + "/ManageMembersController");
        return;
    }
%>

<style>
    .form-container {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .form-header {
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #3498db;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
    }
    .form-group input,
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 1rem;
    }
    .btn-submit {
        background-color: #27ae60;
        color: white;
        padding: 14px 30px;
        border: none;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
    }
    .btn-cancel {
        background-color: #95a5a6;
        color: white;
        padding: 14px 30px;
        border: none;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        text-decoration: none;
        display: inline-block;
        margin-left: 10px;
    }</style>

<div class="form-container">
    <a href="${pageContext.request.contextPath}/ManageMembersController" class="back-link">← Back to Members</a>
    
    <div class="form-header">
        <h2>Edit Member</h2>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/ManageMembersController">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="member_id" value="<%= member.getMemberId() %>">
        
        <div class="form-group">
            <label>Username (Read-only)</label>
            <input type="text" value="<%= member.getUsername() %>" disabled>
        </div>
        
        <div class="form-group">
            <label>Full Name *</label>
            <input type="text" name="full_name" value="<%= member.getFullName() %>" required>
        </div>
        
        <div class="form-group">
            <label>Email *</label>
            <input type="email" name="email" value="<%= member.getEmail() %>" required>
        </div>
        
        <div class="form-group">
            <label>Phone</label>
            <input type="tel" name="phone" value="<%= member.getPhone() != null ? member.getPhone() : "" %>">
        </div>
        
        <div class="form-group">
            <label>Address</label>
            <textarea name="address" rows="3"><%= member.getAddress() != null ? member.getAddress() : "" %></textarea>
        </div>
        
        <div class="form-group">
            <label>Date of Birth</label>
            <input type="date" name="date_of_birth" value="<%= member.getDateOfBirth() != null ? member.getDateOfBirth() : "" %>">
        </div>

        <button type="submit" class="btn-submit">Update Member</button>
        <a href="${pageContext.request.contextPath}/ManageMembersController" class="btn-cancel">Cancel</a>
    </form>
</div>

<%@ include file="/includes/footer.jsp" %>