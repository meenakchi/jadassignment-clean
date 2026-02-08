<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Service, model.ServiceCategory" %>
<%@ include file="/includes/header.jsp" %>

<%
    // Check admin session
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect(request.getContextPath() + "/AdminLoginController");
        return;
    }
    
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<ServiceCategory> categories = (List<ServiceCategory>) request.getAttribute("categories");
    
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

<style>
    .admin-container {
        max-width: 1400px;
        margin: 40px auto;
        padding: 30px;
    }
    .page-header {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .page-header h2 {
        margin: 0;
        color: #2c3e50;
    }
    .btn-add {
        background-color: #27ae60;
        color: white;
        padding: 12px 25px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: 600;
        transition: background-color 0.3s;
    }
    .btn-add:hover {
        background-color: #229954;
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
    .services-table {
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
    .service-image {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 8px;
    }
    .status-badge {
        padding: 5px 12px;
        border-radius: 15px;
        font-size: 0.85rem;
        font-weight: 600;
    }
    .status-active {
        background-color: #d4edda;
        color: #155724;
    }
    .status-inactive {
        background-color: #f8d7da;
        color: #721c24;
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
</style>

<div class="admin-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="page-header">
        <div>
            <h2>Manage Services</h2>
            <p style="color: #7f8c8d; margin: 5px 0 0 0;">Create, edit, and manage all care services</p>
        </div>
        <a href="${pageContext.request.contextPath}/addServices.jsp" class="btn-add">+ Add New Service</a>
    </div>

    <% if (message != null) { %>
        <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="services-table">
        <% if (services == null || services.isEmpty()) { %>
            <div style="text-align: center; padding: 40px; color: #7f8c8d;">
                <h3>No services found</h3>
                <p>Click "Add New Service" to create your first service.</p>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Service Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Duration</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Service service : services) { 
                        String imageUrl = service.getImageUrl();
                        if (imageUrl != null && imageUrl.startsWith("/")) {
                            imageUrl = imageUrl.substring(1);
                        }
                    %>
                        <tr>
                            <td>
                                <img src="${pageContext.request.contextPath}/<%= imageUrl %>" 
                                     alt="<%= service.getServiceName() %>"
                                     class="service-image"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-service.jpg'">
                            </td>
                            <td><%= service.getServiceName() %></td>
                            <td><%= service.getCategoryName() %></td>
                            <td>$<%= String.format("%.2f", service.getPrice()) %></td>
                            <td><%= service.getDuration() %> mins</td>
                            <td>
                                <span class="status-badge <%= service.isActive() ? "status-active" : "status-inactive" %>">
                                    <%= service.isActive() ? "Active" : "Inactive" %>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/editService.jsp?id=<%= service.getServiceId() %>" 
                                   class="action-btn btn-edit">Edit</a>
                                <a href="${pageContext.request.contextPath}/ManageServicesController?action=delete&id=<%= service.getServiceId() %>" 
                                   class="action-btn btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this service?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
