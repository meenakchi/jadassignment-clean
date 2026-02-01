<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/includes/header.jsp" %>

<%
    String adminName = (String) session.getAttribute("admin_name");
    String adminUsername = (String) session.getAttribute("admin_username");
    
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    Integer totalServices = (Integer) request.getAttribute("totalServices");
    Integer activeServices = (Integer) request.getAttribute("activeServices");
    
    if(totalMembers == null) totalMembers = 0;
    if(totalServices == null) totalServices = 0;
    if(activeServices == null) activeServices = 0;
%>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f8;
        margin: 0;
        padding: 0;
    }
    .admin-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    }
    .welcome-banner {
        text-align: center;
        background-color: #3498db;
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .dashboard-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }
    .dashboard-header h2 {
        color: #333;
        margin: 0;
    }
    .logout-btn {
        background-color: #e74c3c;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        text-decoration: none;
        font-weight: bold;
        transition: background-color 0.3s;
    }
    .logout-btn:hover {
        background-color: #c0392b;
    }
    .section-title {
        font-size: 22px;
        margin-bottom: 15px;
        color: #2c3e50;
        border-bottom: 2px solid #3498db;
        padding-bottom: 8px;
    }
    .stats-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 30px;
    }
    .stat-card {
        background-color: #f8f9fa;
        border-left: 4px solid #3498db;
        padding: 20px;
        border-radius: 8px;
    }
    .stat-number {
        font-size: 32px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    .stat-label {
        color: #7f8c8d;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-size: 14px;
    }
    .management-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 20px;
    }
    .management-card {
        padding: 20px;
        background-color: #f8f9fa;
        border-radius: 10px;
        border-left: 4px solid #3498db;
    }
    .management-card h3 {
        margin-top: 0;
        color: #2c3e50;
    }
    .manage-btn {
        display: inline-block;
        padding: 12px 20px;
        background-color: #2ecc71;
        color: white;
        border-radius: 5px;
        font-weight: bold;
        text-decoration: none;
        margin-top: 10px;
        transition: background-color 0.3s;
    }
    .manage-btn:hover {
        background-color: #27ae60;
    }
</style>

<div class="admin-container">
    <div class="dashboard-header">
        <h2>Welcome, <%= adminName != null ? adminName : adminUsername %>!</h2>
        <a href="${pageContext.request.contextPath}/LogoutController" class="logout-btn">Logout</a>
    </div>

    <div class="welcome-banner">
        <h3>Administrator Dashboard</h3>
        <p>Manage system settings, members, services, bookings, and feedback.</p>
    </div>

    <h3 class="section-title">System Statistics</h3>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number"><%= totalMembers %></div>
            <div class="stat-label">Total Members</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= totalServices %></div>
            <div class="stat-label">Total Services</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= activeServices %></div>
            <div class="stat-label">Active Services</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">3</div>
            <div class="stat-label">Service Categories</div>
        </div>
    </div>

    <h3 class="section-title">Management Tools</h3>
    <div class="management-grid">
        <div class="management-card">
            <h3>Manage Services</h3>
            <p>Create, update, and delete available services.</p>
            <a href="${pageContext.request.contextPath}/ManageServicesController" class="manage-btn">Manage Services</a>
        </div>
        
        <div class="management-card">
            <h3>Manage Members</h3>
            <p>View, update, and manage registered members.</p>
            <a href="${pageContext.request.contextPath}/ManageMembersController" class="manage-btn">Manage Members</a>
        </div>
        
        <div class="management-card">
            <h3>Manage Bookings</h3>
            <p>View and manage customer bookings with real-time status updates.</p>
            <a href="${pageContext.request.contextPath}/ManageBookingsController" class="manage-btn">Manage Bookings</a>
        </div>
        
        <div class="management-card">
            <h3>View Feedback</h3>
            <p>View all customer feedback and ratings.</p>
            <a href="${pageContext.request.contextPath}/ViewFeedbackController" class="manage-btn">View Feedback</a>
        </div>
        
        <div class="management-card">
            <h3>Sales Reports</h3>
            <p>Generate sales and revenue reports.</p>
            <a href="${pageContext.request.contextPath}/SalesReportController" class="manage-btn">View Reports</a>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>