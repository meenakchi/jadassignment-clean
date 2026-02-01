<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="model.Booking" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    BigDecimal revenue = (BigDecimal) request.getAttribute("revenue");
    String reportType = (String) request.getAttribute("reportType");
    Object startDate = request.getAttribute("startDate");
    Object endDate = request.getAttribute("endDate");
%>

<style>
    .report-container {
        max-width: 1400px;
        margin: 40px auto;
        padding: 30px;
    }
    .report-header {
        background: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .revenue-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
        text-align: center;
        margin-bottom: 30px;
    }
    .revenue-amount {
        font-size: 3rem;
        font-weight: bold;
        margin-top: 10px;
    }
    .filter-buttons {
        display: flex;
        gap: 10px;
        margin-top: 20px;
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
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="report-header">
        <h2>Sales Report</h2>
        <p>Period: <%= startDate %> to <%= endDate %></p>
        
        <div class="filter-buttons">
            <a href="?type=today" class="filter-btn <%= "today".equals(reportType) ? "active" : "" %>">Today</a>
            <a href="?type=week" class="filter-btn <%= "week".equals(reportType) ? "active" : "" %>">This Week</a>
            <a href="?type=month" class="filter-btn <%= "month".equals(reportType) ? "active" : "" %>">This Month</a>
            <a href="?type=year" class="filter-btn <%= "year".equals(reportType) ? "active" : "" %>">This Year</a>
        </div>
    </div>

    <div class="revenue-card">
        <div style="font-size: 1.3rem;">Total Revenue</div>
        <div class="revenue-amount">$<%= String.format("%.2f", revenue) %></div>
        <div style="margin-top: 10px;"><%= bookings != null ? bookings.size() : 0 %> bookings</div>
    </div>

    <% if (bookings != null && !bookings.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Member</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                <% for (Booking booking : bookings) { %>
                    <tr>
                        <td>#<%= booking.getBookingId() %></td>
                        <td><%= booking.getMemberName() %></td>
                        <td><%= booking.getBookingDate() %></td>
                        <td>
                            <span class="status-badge status-<%= booking.getStatus() %>">
                                <%= booking.getStatus() %>
                            </span>
                        </td>
                        <td>$<%= String.format("%.2f", booking.getTotalAmount()) %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <div style="text-align: center; padding: 60px; background: white; border-radius: 10px;">
            <h3>No bookings found for this period</h3>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>