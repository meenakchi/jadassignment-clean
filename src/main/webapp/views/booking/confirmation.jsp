
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.BookingDetail" %>
<%@ page import="java.util.List" %>
<%@ include file="/includes/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    List<BookingDetail> bookingDetails = (List<BookingDetail>) request.getAttribute("bookingDetails");
    Boolean paymentSuccess = (Boolean) session.getAttribute("payment_success");
    
    if (paymentSuccess != null && paymentSuccess) {
        session.removeAttribute("payment_success");
    }
%>

<style>
    .confirmation-container {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
        text-align: center;
    }
    .success-icon {
        font-size: 80px;
        color: #27ae60;
        margin-bottom: 20px;
    }
    .confirmation-card {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        margin-top: 30px;
    }
    .booking-id {
        font-size: 2rem;
        color: #3498db;
        font-weight: bold;
        margin: 20px 0;
    }
    .booking-details {
        text-align: left;
        margin-top: 30px;
        background: #f8f9fa;
        padding: 25px;
        border-radius: 8px;
    }
    .detail-row {
        display: flex;
        justify-content: space-between;
        padding: 12px 0;
        border-bottom: 1px solid #e0e0e0;
    }
    .detail-row:last-child {
        border-bottom: none;
    }
    .detail-label {
        font-weight: 600;
        color: #2c3e50;
    }
    .services-list {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 2px solid #3498db;
    }
    .service-item {
        padding: 10px;
        background: white;
        border-radius: 5px;
        margin: 10px 0;
        display: flex;
        justify-content: space-between;
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
    .btn-primary {
        background-color: #3498db;
        color: white;
    }
    .btn-secondary {
        background-color: #95a5a6;
        color: white;
    }
</style>

<div class="confirmation-container">
    <div class="success-icon">✓</div>
    
    <% if (paymentSuccess != null && paymentSuccess) { %>
        <h2>Payment Successful!</h2>
    <% } else { %>
        <h2>Booking Confirmed!</h2>
    <% } %>
    
    <p style="color: #7f8c8d; margin-top: 10px;">
        Your booking has been successfully placed.
    </p>
    
    <% if (booking != null) { %>
        <div class="booking-id">
            Booking #<%= booking.getBookingId() %>
        </div>
        
        <div class="confirmation-card">
            <div class="booking-details">
                <h3>Booking Information</h3>
                
                <div class="detail-row">
                    <span class="detail-label">Date:</span>
                    <span><%= booking.getBookingDate() %></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Time:</span>
                    <span><%= booking.getBookingTime() %></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Total Amount:</span>
                    <span style="font-size: 1.2rem; font-weight: bold; color: #27ae60;">
                        $<%= String.format("%.2f", booking.getTotalAmount()) %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Status:</span>
                    <span style="color: #27ae60; font-weight: 600;"><%= booking.getStatus() %></span>
                </div>
                
                <% if (booking.getSpecialRequests() != null && !booking.getSpecialRequests().isEmpty()) { %>
                    <div class="detail-row">
                        <span class="detail-label">Special Requests:</span>
                        <span><%= booking.getSpecialRequests() %></span>
                    </div>
                <% } %>
                
                <% if (bookingDetails != null && !bookingDetails.isEmpty()) { %>
                    <div class="services-list">
                        <h4>Services Booked:</h4>
                        <% for (BookingDetail detail : bookingDetails) { %>
                            <div class="service-item">
                                <div>
                                    <strong><%= detail.getServiceName() %></strong>
                                    <br>
                                    <small>Quantity: <%= detail.getQuantity() %></small>
                                </div>
                                <div>
                                    $<%= String.format("%.2f", detail.getSubtotal()) %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <p style="margin-top: 20px; color: #7f8c8d;">
                <strong>What's Next?</strong><br>
                Our team will contact you shortly to confirm the details. 
                You can view your booking history anytime from your dashboard.
            </p>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/MemberDashboardController" class="btn btn-primary">
                    Go to Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/BookingHistoryController" class="btn btn-secondary">
                    View All Bookings
                </a>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>