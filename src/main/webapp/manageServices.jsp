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
        int serviceId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM service WHERE service_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, serviceId);
            
            int rows = pstmt.executeUpdate();
            if(rows > 0) {
                message = "Service deleted successfully!";
                messageType = "success";
            }
        } catch(Exception e) {
            message = "Error deleting service: " + e.getMessage();
            messageType = "error";
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
    
    // Handle TOGGLE ACTIVE status
    if("toggle".equals(request.getParameter("action"))) {
        int serviceId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE service SET is_active = NOT is_active WHERE service_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, serviceId);
            
            pstmt.executeUpdate();
            message = "Service status updated!";
            messageType = "success";
        } catch(Exception e) {
            message = "Error updating status: " + e.getMessage();
            messageType = "error";
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
    
    // Fetch all services
    List<Map<String, Object>> services = new ArrayList<Map<String, Object>>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT s.*, sc.category_name FROM service s " +
                     "JOIN service_category sc ON s.category_id = sc.category_id " +
                     "ORDER BY s.service_name";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> service = new HashMap<String, Object>();
            service.put("service_id", rs.getInt("service_id"));
            service.put("service_name", rs.getString("service_name"));
            service.put("description", rs.getString("description"));
            service.put("price", rs.getBigDecimal("price"));
            service.put("duration", rs.getInt("duration"));
            service.put("category_name", rs.getString("category_name"));
            service.put("is_active", rs.getBoolean("is_active"));
            services.add(service);
        }
    } catch(Exception e) {
        message = "Error loading services: " + e.getMessage();
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
        padding: 12px 24px;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
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
        background-color: #3498db;
        color: white;
    }
    .btn-toggle {
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
    .no-services {
        text-align: center;
        padding: 40px;
        color: #7f8c8d;
    }
</style>

<div class="admin-container">
    <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
    
    <div class="page-header">
        <h2>Manage Services</h2>
        <a href="addServices.jsp" class="btn-add">+ Add New Service</a>
    </div>

    <% if(!messageType.isEmpty()) { %>
        <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="services-table">
        <% if(services.isEmpty()) { %>
            <div class="no-services">
                <h3>No services found</h3>
                <p>Click "Add New Service" to create your first service.</p>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Service Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Duration</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, Object> service : services) { %>
                        <tr>
                            <td><%= service.get("service_id") %></td>
                            <td><%= service.get("service_name") %></td>
                            <td><%= service.get("category_name") %></td>
                            <td>$<%= service.get("price") %></td>
                            <td><%= service.get("duration") %> mins</td>
                            <td>
                                <span class="status-badge <%= (Boolean)service.get("is_active") ? "status-active" : "status-inactive" %>">
                                    <%= (Boolean)service.get("is_active") ? "Active" : "Inactive" %>
                                </span>
                            </td>
                            <td>
                                <a href="editService.jsp?id=<%= service.get("service_id") %>" class="action-btn btn-edit">Edit</a>
                                <a href="manageServices.jsp?action=toggle&id=<%= service.get("service_id") %>" 
                                   class="action-btn btn-toggle"
                                   onclick="return confirm('Toggle service status?')">
                                    <%= (Boolean)service.get("is_active") ? "Deactivate" : "Activate" %>
                                </a>
                                <a href="manageServices.jsp?action=delete&id=<%= service.get("service_id") %>" 
                                   class="action-btn btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this service?')">
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
