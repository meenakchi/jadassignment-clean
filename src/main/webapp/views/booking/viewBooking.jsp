
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.BookingDetail" %>
<%@ page import="java.util.List" %>
<%@ include file="/includes/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    List<BookingDetail> bookingDetails = (List<BookingDetail>) request.getAttribute("bookingDetails");
    Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
    if (isAdmin == null) isAdmin = false;
%>

<style>
    .booking-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
    }
    .booking-card {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    .booking-header {
        text-align: center;
        padding-bottom: 30px;
        border-bottom: 2px solid #3498db;
        margin-bottom: 30px;
    }
    .booking-id {
        font-size: 2.5rem;
        color: #3498db;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .status-badge {
        padding: 10px 25px;
        border-radius: 25px;
        font-weight: 600;
        font-size: 1rem;
        display: inline-block;
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
    .info-section {
        background: #f8f9fa;
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 25px;
    }
    .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
    }
    .info-item {
        display: flex;
        flex-direction: column;
    }
    .info-label {
        font-size: 0.9rem;
        color: #7f8c8d;
        margin-bottom: 8px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .info-value {
        font-size: 1.2rem;
        color: #2c3e50;
        font-weight: 600;
    }
    .services-section {
        margin-top: 30px;
    }
    .services-section h3 {
        margin-bottom: 20px;
        color: #2c3e50;
    }
    .service-item {
        background: white;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 15px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .service-info {
        flex: 1;
    }
    .service-name {
        font-size: 1.2rem;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    .service-qty {
        color: #7f8c8d;
        font-size: 0.95rem;
    }
    .service-price {
        font-size: 1.3rem;
        font-weight: bold;
        color: #27ae60;
    }
    .total-section {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 25px;
        border-radius: 8px;
        margin-top: 25px;
        text-align: right;
    }
    .total-label {
        font-size: 1.2rem;
        margin-bottom: 10px;
    }
    .total-amount {
        font-size: 2.5rem;
        font-weight: bold;
    }
    .action-buttons {
        margin-top: 30px;
        display: flex;
        gap: 15px;
        justify-content: center;
    }
    .btn {
        padding: 15px 30px;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        transition: opacity 0.3s;
    }
    .btn:hover {
        opacity: 0.8;
    }
    .btn-back {
        background-color: #95a5a6;
        color: white;
    }
</style>

<div class="booking-container">
    <% if (booking != null) { %>
        <div class="booking-card">
            <div class="booking-header">
                <div class="booking-id">
                    Booking #<%= booking.getBookingId() %>
                </div>
                <div class="status-badge status-<%= booking.getStatus() %>">
                    <%= booking.getStatus() %>
                </div>
            </div>
            
            <div class="info-section">
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Booking Date</span>
                        <span class="info-value"><%= booking.getBookingDate() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Booking Time</span>
                        <span class="info-value"><%= booking.getBookingTime() %></span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Created On</span>
                        <span class="info-value">
                            <%= String.format("%1$tB %1$te, %1$tY", booking.getCreatedAt()) %>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <span class="info-label">Status</span>
                        <span class="info-value"><%= booking.getStatus() %></span>
                    </div>
                </div>
                
                <% if (booking.getSpecialRequests() != null && !booking.getSpecialRequests().isEmpty()) { %>
                    <div class="info-item" style="margin-top: 20px;">
                        <span class="info-label">Special Requests</span>
                        <span class="info-value" style="font-size: 1rem; font-weight: normal;">
                            <%= booking.getSpecialRequests() %>
                        </span>
                    </div>
                <% } %>
            </div>
            
            <% if (bookingDetails != null && !bookingDetails.isEmpty()) { %>
<div class="services-section">
<h3>Services Booked</h3>
<% for (BookingDetail detail : bookingDetails) { %>
<div class="service-item">
<div class="service-info">
<div class="service-name"><%= detail.getServiceName() %></div>
<div class="service-qty">
Quantity: <%= detail.getQuantity() %> ×
$<%= String.format("%.2f", detail.getServicePrice()) %>
</div>
</div>
<div class="service-price">
$<%= String.format("%.2f", detail.getSubtotal()) %>
</div>
</div>
<% } %>
</div>
<% } %><div class="total-section">
            <div class="total-label">Total Amount</div>
            <div class="total-amount">
                $<%= String.format("%.2f", booking.getTotalAmount()) %>
            </div>
        </div>
        
        <div class="action-buttons">
            <% if (isAdmin) { %>
                <a href="${pageContext.request.contextPath}/ManageBookingsController" class="btn btn-back">
                    ← Back to Bookings
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/BookingHistoryController" class="btn btn-back">
                    ← Back to History
                </a>
            <% } %>
        </div>
    </div>
<% } else { %>
    <div class="booking-card" style="text-align: center;">
        <h3>Booking not found</h3>
        <p style="color: #7f8c8d; margin: 20px 0;">
            The booking you're looking for doesn't exist or you don't have permission to view it.
        </p>
        <a href="${pageContext.request.contextPath}/MemberDashboardController" class="btn btn-back">
            Go to Dashboard
        </a>
    </div>
<% } %> </div>
<%@ include file="/includes/footer.jsp" %>