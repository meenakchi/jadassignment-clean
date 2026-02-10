<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Service" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    Map<Integer, Integer> bookingCounts = (Map<Integer, Integer>) request.getAttribute("bookingCounts");
    String reportTitle = (String) request.getAttribute("reportTitle");
    String reportType = (String) request.getAttribute("reportType");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .filter-buttons {
        display: flex;
        gap: 10px;
        margin: 20px 0;
    }
    .filter-btn {
        padding: 10px 20px;
        border: 2px solid #3498db;
        background: white;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        color: #3498db;
        font-weight: 600;
    }
    .filter-btn.active {
        background: #3498db;
        color: white;
    }
    table {
        width: 100%;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    thead {
        background: #34495e;
        color: white;
    }
    th, td {
        padding: 15px;
        text-align: left;
    }
    tr {
        border-bottom: 1px solid #ecf0f1;
    }
    .demand-badge {
        padding: 5px 12px;
        border-radius: 15px;
        font-size: 0.85rem;
        font-weight: 600;
    }
    .demand-high {
        background-color: #f8d7da;
        color: #721c24;
    }
    .demand-medium {
        background-color: #fff3cd;
        color: #856404;
    }
    .demand-low {
        background-color: #d4edda;
        color: #155724;
    }
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <h2 style="margin: 20px 0;"><%= reportTitle %></h2>
    
    <div class="filter-buttons">
        <a href="?action=high_demand" class="filter-btn <%= "high_demand".equals(reportType) ? "active" : "" %>">
            High Demand
        </a>
        <a href="?action=low_availability" class="filter-btn <%= "low_availability".equals(reportType) ? "active" : "" %>">
            Low Availability
        </a>
    </div>

    <% if (services == null || services.isEmpty()) { %>
        <div style="text-align: center; padding: 60px; background: white; border-radius: 10px;">
            <h3>No services found</h3>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <% if ("high_demand".equals(reportType)) { %>
                        <th>Total Bookings</th>
                        <th>Demand Level</th>
                    <% } else { %>
                        <th>Status</th>
                        <th>Availability</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
                <% for (Service service : services) { %>
                    <tr>
                        <td><%= service.getServiceName() %></td>
                        <td><%= service.getCategoryName() %></td>
                        <td>$<%= String.format("%.2f", service.getPrice()) %></td>
                        
                        <% if ("high_demand".equals(reportType)) { 
                            int count = bookingCounts.getOrDefault(service.getServiceId(), 0);
                            String demandClass = count > 10 ? "demand-high" : count > 5 ? "demand-medium" : "demand-low";
                            String demandText = count > 10 ? "High" : count > 5 ? "Medium" : "Low";
                        %>
                            <td><%= count %></td>
                            <td>
                                <span class="demand-badge <%= demandClass %>">
                                    <%= demandText %>
                                </span>
                            </td>
                        <% } else { %>
                            <td>
                                <span class="status-badge <%= service.isActive() ? "status-active" : "status-inactive" %>">
                                    <%= service.isActive() ? "Active" : "Inactive" %>
                                </span>
                            </td>
                            <td>
                                <%= service.isActive() ? "Available" : "Not Available" %>
                            </td>
                        <% } %>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
