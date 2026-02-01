
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<style>
    .history-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 30px;
    }
    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }
    .page-header h2 {
        font-size: 2.5rem;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    .bookings-grid {
        display: grid;
        gap: 20px;
    }
    .booking-card {
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }
    .booking-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }
    .booking-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #ecf0f1;
    }
    .booking-id {
        font-size: 1.5rem;
        font-weight: bold;
        color: #3498db;
    }
    .status-badge {
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
    }
    .status-PENDING {
        background-color: #fff3cd;
        color: #856404;
    }
    .status-CONFIRMED {
        background-color: #d4edda;
        color: #155724;
    }
    .status-COMPLETED {
        background-color: #d1ecf1;
        color: #0c5460;
    }
    .status-CANCELLED {
        background-color: #f8d7da;
        color: #721c24;
    }
    .booking-details {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
    .detail-item {
        display: flex;
        flex-direction: column;
    }
    .detail-label {
        font-size: 0.9rem;
        color: #7f8c8d;
        margin-bottom: 5px;
    }
    .detail-value {
        font-size: 1.1rem;
        color: #2c3e50;
        font-weight: 600;
    }
    .total-amount {
        color: #27ae60;
        font-size: 1.5rem;
    }
    .view-btn {
        margin-top: 20px;
        padding: 12px 24px;
        background-color: #3498db;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        font-weight: 600;
        transition: background-color 0.3s;
    }
    .view-btn:hover {
        background-color: #2980b9;
    }
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .empty-state h3 {
        font-size: 2rem;
        color: #7f8c8d;
        margin-bottom: 15px;
    }
</style>

<div class="history-container">
    <div class="page-header">
        <h2>Booking History</h2>
        <p style="color: #7f8c8d;">View all your past and upcoming bookings</p>
    </div>
    
    <% if (bookings == null || bookings.isEmpty()) { %>
        <div class="empty-state">
            <h3>No bookings yet</h3>
            <p style="color: #95a5a6; margin-bottom: 25px;">
                You haven't made any bookings. Browse our services and make your first booking!
            </p>
            <a href="${pageContext.request.contextPath}/ServicesController" class="view-btn">
                Browse Services
            </a>
        </div>
    <% } else { %>
        <div class="bookings-grid">
            <% for (Booking booking : bookings) { %>
                <div class="booking-card">
                    <div class="booking-header">
                        <div class="booking-id">
                            Booking #<%= booking.getBookingId() %>
                        </div>
                        <div class="status-badge status-<%= booking.getStatus() %>">
                            <%= booking.getStatus() %>
                        </div>
                    </div>
                    
                    <div class="booking-details">
                        <div class="detail-item">
                            <span class="detail-label">Date</span>
                            <span class="detail-value"><%= booking.getBookingDate() %></span>
                        </div>
                        
                        <div class="detail-item">
                            <span class="detail-label">Time</span>
                            <span class="detail-value"><%= booking.getBookingTime() %></span>
                        </div>
                        
                        <div class="detail-item">
                            <span class="detail-label">Booked On</span>
                            <span class="detail-value">
                                <%= String.format("%1$tB %1$te, %1$tY", booking.getCreatedAt()) %>
                            </span>
                        </div>
                        
                        <div class="detail-item">
                            <span class="detail-label">Total Amount</span>
                            <span class="detail-value total-amount">
                                $<%= String.format("%.2f", booking.getTotalAmount()) %>
                            </span>
                        </div>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/ViewBookingController?id=<%= booking.getBookingId() %>" 
                       class="view-btn">
                        View Details
                    </a>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>