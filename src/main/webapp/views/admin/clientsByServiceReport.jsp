<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Member, model.Service" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Service> allServices = (List<Service>) request.getAttribute("allServices");
    Service selectedService = (Service) request.getAttribute("service");
    List<Member> members = (List<Member>) request.getAttribute("members");
    Integer selectedServiceId = (Integer) request.getAttribute("selectedServiceId");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .filter-section {
        background: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .filter-section select {
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 1rem;
        min-width: 300px;
    }
    .filter-btn {
        padding: 12px 30px;
        background: #3498db;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: 600;
        margin-left: 10px;
    }
    .filter-btn:hover {
        background: #2980b9;
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
    
    <h2 style="margin: 20px 0;">Clients by Service</h2>
    
    <div class="filter-section">
        <form method="get" action="${pageContext.request.contextPath}/ClientsByServiceController">
            <label style="font-weight: 600; margin-right: 10px;">Select Service:</label>
            <select name="service_id" required>
                <option value="">-- Choose a Service --</option>
                <% if (allServices != null) {
                    for (Service service : allServices) { %>
                        <option value="<%= service.getServiceId() %>" 
                                <%= selectedServiceId != null && selectedServiceId == service.getServiceId() ? "selected" : "" %>>
                            <%= service.getServiceName() %> (<%= service.getCategoryName() %>)
                        </option>
                    <% }
                } %>
            </select>
            <button type="submit" class="filter-btn">Generate Report</button>
        </form>
    </div>

    <% if (selectedService != null) { %>
        <div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px;">
            <h3>Service: <%= selectedService.getServiceName() %></h3>
            <p style="color: #7f8c8d;">
                Category: <%= selectedService.getCategoryName() %> | 
                Price: $<%= String.format("%.2f", selectedService.getPrice()) %> | 
                Duration: <%= selectedService.getDuration() %> minutes
            </p>
            <p style="margin-top: 10px; font-weight: 600;">
                Total Clients: <%= members != null ? members.size() : 0 %>
            </p>
        </div>

        <% if (members == null || members.isEmpty()) { %>
            <div style="text-align: center; padding: 60px; background: white; border-radius: 10px;">
                <h3>No clients have booked this service yet</h3>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Client Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Member Since</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Member member : members) { %>
                        <tr>
                            <td><%= member.getFullName() %></td>
                            <td><%= member.getEmail() %></td>
                            <td><%= member.getPhone() != null ? member.getPhone() : "N/A" %></td>
                            <td><%= member.getAddress() != null ? member.getAddress() : "N/A" %></td>
                            <td><%= String.format("%1$tB %1$te, %1$tY", member.getCreatedAt()) %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
