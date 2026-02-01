<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
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
    .action-buttons-group {
        display: flex;
        gap: 5px;
        flex-wrap: wrap;
    }
    .status-action-btn {
        padding: 5px 10px;
        font-size: 0.8rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        color: white;
        transition: opacity 0.3s;
    }
    .status-action-btn:hover {
        opacity: 0.8;
    }
    .btn-checkin {
        background-color: #3498db;
    }
    .btn-checkout {
        background-color: #27ae60;
    }
    .btn-cancel {
        background-color: #e74c3c;
    }
</style>

<div class="admin-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="page-header">
        <h2>Manage Bookings</h2>
        <p style="color: #7f8c8d; margin: 5px 0 0 0;">View and manage all customer bookings with real-time status updates</p>
    </div>

    <% if (message != null) { %>
        <div class="message <%= messageType %>"><%= message %></div>
    <% } %>

    <div class="bookings-table">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <div style="text-align: center; padding: 40px; color: #7f8c8d;">
                <h3>No bookings found</h3>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Member</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Quick Actions</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Booking booking : bookings) { 
                        String status = booking.getStatus();
                    %>
                        <tr>
                            <td>#<%= booking.getBookingId() %></td>
                            <td>
                                <%= booking.getMemberName() %><br>
                                <small style="color: #7f8c8d;"><%= booking.getMemberEmail() %></small>
                            </td>
                            <td><%= booking.getBookingDate() %></td>
                            <td><%= booking.getBookingTime() %></td>
                            <td>$<%= String.format("%.2f", booking.getTotalAmount()) %></td>
                            <td>
                                <span class="status-badge status-<%= status %>">
                                    <%= status %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons-group">
                                    <% if ("CONFIRMED".equals(status)) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/BookingStatusController" style="display: inline;">
                                            <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
                                            <input type="hidden" name="action" value="checkin">
                                            <button type="submit" class="status-action-btn btn-checkin" 
                                                    onclick="return confirm('Mark as service started?')">
                                                Check-in
                                            </button>
                                        </form>
                                    <% } %>
                                    
                                    <% if ("IN_PROGRESS".equals(status)) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/BookingStatusController" style="display: inline;">
                                            <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
                                            <input type="hidden" name="action" value="checkout">
                                            <button type="submit" class="status-action-btn btn-checkout" 
                                                    onclick="return confirm('Mark as completed?')">
                                                Check-out
                                            </button>
                                        </form>
                                    <% } %>
                                    
                                    <% if (!"CANCELLED".equals(status) && !"COMPLETED".equals(status)) { %>
                                        <form method="post" action="${pageContext.request.contextPath}/BookingStatusController" style="display: inline;">
                                            <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
                                            <input type="hidden" name="action" value="cancel">
                                            <button type="submit" class="status-action-btn btn-cancel" 
                                                    onclick="return confirm('Cancel this booking?')">
                                                Cancel
                                            </button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ViewBookingController?id=<%= booking.getBookingId() %>" 
                                   class="action-btn btn-view">View Details</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<script>
// Auto-refresh page every 30 seconds to show updated statuses
setTimeout(function() {
    location.reload();
}, 30000);
</script>

<%@ include file="/includes/footer.jsp" %>