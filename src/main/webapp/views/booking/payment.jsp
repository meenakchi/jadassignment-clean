<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ include file="/includes/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
%>

<style>
    .payment-container { max-width: 600px; margin: 40px auto; padding: 30px; }
    .payment-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
    .amount-display { 
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
        color: white; padding: 30px; border-radius: 8px; text-align: center; margin-bottom: 30px; 
    }
    .amount-value { font-size: 3rem; font-weight: bold; }
    .btn-pay { 
        width: 100%; background-color: #27ae60; color: white; padding: 18px; border: none; 
        border-radius: 5px; font-size: 1.2rem; font-weight: bold; cursor: pointer; 
    }
    .btn-pay:hover { background-color: #229954; }
</style>

<div class="payment-container">
    <% if (booking != null) { %>
        <div class="payment-card">
            <h2 style="text-align:center;">Review Payment</h2>
            <p style="text-align:center; color: #7f8c8d;">Booking #<%= booking.getBookingId() %></p>
            
            <div class="amount-display">
                <div style="opacity: 0.9;">Total to Pay</div>
                <div class="amount-value">$<%= String.format("%.2f", booking.getTotalAmount()) %></div>
            </div>
            
            <form method="post" action="${pageContext.request.contextPath}/PaymentController">
                <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
                
                <p style="margin-bottom: 20px; color: #2c3e50; text-align: center;">
                    You will be redirected to <strong>Stripe</strong> to complete your transaction safely.
                </p>
                
                <button type="submit" class="btn-pay">Proceed to Stripe</button>
            </form>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>