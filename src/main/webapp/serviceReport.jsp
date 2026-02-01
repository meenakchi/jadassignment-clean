<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Service" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    Map<Integer, Double> ratings = (Map<Integer, Double>) request.getAttribute("ratings");
    String reportTitle = (String) request.getAttribute("reportTitle");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .report-header {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .report-filters {
        display: flex;
        gap: 15px;
    }
    .filter-btn {
        padding: 10px 20px;
        border: 2px solid #3498db;
        background: white;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        color: #3498db;
        font-weight: 600;
    }
    .filter-btn:hover {
        background: #3498db;
        color: white;
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
    th, td {
        padding: 15px;
        text-align: left;
    }
    td {
        border-bottom: 1px solid #ecf0f1;
    }
    tbody tr:hover {
        background-color: #f8f9fa;
    }
    .rating-stars {
        color: #f39c12;
        font-size: 1.2rem;
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
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="report-header">
        <h2><%= reportTitle %></h2>
        <div class="report-filters">
            <a href="?action=best_rated" class="filter-btn">Best Rated</a>
            <a href="?action=lowest_rated" class="filter-btn">Lowest Rated</a>
            <a href="?action=list" class="filter-btn">All Services</a>
        </div>
    </div>

    <div class="services-table">
        <% if (services == null || services.isEmpty()) { %>
            <div style="text-align: center; padding: 40px; color: #7f8c8d;">
                <h3>no services found</h3>
</div>
<% } else { %>
<table>
<thead>
<tr>
<th>ID</th>
<th>Service Name</th>
<th>Category</th>
<th>Price</th>
<% if (ratings != null) { %>
<th>Average Rating</th>
<% } %>
<th>Status</th>
</tr>
</thead>
<tbody>
<% for (Service service : services) { %>
<tr>
<td><%= service.getServiceId() %></td>
<td><%= service.getServiceName() %></td>
<td><%= service.getCategoryName() %></td>
<td>$<%= String.format("%.2f", service.getPrice()) %></td>
<% if (ratings != null) {
Double rating = ratings.get(service.getServiceId());
int stars = rating != null ? (int) Math.round(rating) : 0;
%>
<td>
<span class="rating-stars">
<% for (int i = 0; i < 5; i++) { %>
<%= i < stars ? "★" : "☆" %>
<% } %>
</span>
<%= rating != null ? String.format("%.1f", rating) : "No ratings" %>
</td>
<% } %>
<td>
<span class="status-badge <%= service.isActive() ? "status-active" : "status-inactive" %>">
<%= service.isActive() ? "Active" : "Inactive" %>
</span>
</td>
</tr>
<% } %>
</tbody>
</table>
<% } %>
</div>

</div>
<%@ include file="/includes/footer.jsp" %></h3>