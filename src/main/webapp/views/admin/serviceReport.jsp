<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Service" %>
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
    .rating-stars {
        color: #f39c12;
        font-size: 1.2rem;
    }
    .rating-value {
        font-weight: bold;
        color: #2c3e50;
    }
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <h2 style="margin: 20px 0;"><%= reportTitle %></h2>
    
    <div class="filter-buttons">
        <a href="${pageContext.request.contextPath}/ServiceSearchController?action=best_rated" class="filter-btn">
            Best Rated Services
        </a>
        <a href="${pageContext.request.contextPath}/ServiceSearchController?action=lowest_rated" class="filter-btn">
            Lowest Rated Services
        </a>
        <a href="${pageContext.request.contextPath}/ServiceSearchController?action=list" class="filter-btn">
            All Services
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
                    <th>Rank</th>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Average Rating</th>
                    <th>Rating Stars</th>
                </tr>
            </thead>
            <tbody>
                <% 
                int rank = 1;
                for (Service service : services) { 
                    double avgRating = ratings != null ? 
                        ratings.getOrDefault(service.getServiceId(), 0.0) : 0.0;
                    int fullStars = (int) Math.floor(avgRating);
                    boolean hasHalfStar = (avgRating - fullStars) >= 0.5;
                %>
                    <tr>
                        <td><%= rank++ %></td>
                        <td><%= service.getServiceName() %></td>
                        <td><%= service.getCategoryName() %></td>
                        <td>$<%= String.format("%.2f", service.getPrice()) %></td>
                        <td class="rating-value">
                            <%= String.format("%.2f", avgRating) %> / 5.0
                        </td>
                        <td class="rating-stars">
                            <% for (int i = 0; i < fullStars; i++) { %>
                                ★
                            <% } %>
                            <% if (hasHalfStar) { %>
                                ⯨
                            <% } %>
                            <% for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) { %>
                                ☆
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
