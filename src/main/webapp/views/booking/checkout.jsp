
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal cartTotal = (BigDecimal) request.getAttribute("cartTotal");
    BigDecimal gst = (BigDecimal) request.getAttribute("gst");
    BigDecimal totalWithGST = (BigDecimal) request.getAttribute("totalWithGST");
%>

<style>
    .checkout-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
    }
    .checkout-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 30px;
    }
    .checkout-section {
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .section-title {
        font-size: 1.5rem;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #3498db;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 1rem;
        transition: border-color 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        border-color: #3498db;
        outline: none;
    }
    .order-summary {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    .summary-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #e0e0e0;
    }
    .summary-row:last-child {
        border-bottom: none;
        font-weight: bold;
        font-size: 1.2rem;
        padding-top: 15px;
    }
    .cart-item {
        padding: 15px;
        background: white;
        border-radius: 5px;
        margin-bottom: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .btn-submit {
        width: 100%;
        background-color: #27ae60;
        color: white;
        padding: 15px;
        border: none;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .btn-submit:hover {
        background-color: #229954;
    }
    .payment-options {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
        margin-top: 10px;
    }
    .payment-option {
        padding: 15px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        cursor: pointer;
        transition: all 0.3s;
        text-align: center;
    }
    .payment-option:hover {
        border-color: #3498db;
    }
    .payment-option input[type="radio"] {
        margin-right: 8px;
    }
</style>

<div class="checkout-container">
    <h2 style="text-align: center; margin-bottom: 30px;">Checkout</h2>
    
    <form method="post" action="${pageContext.request.contextPath}/CheckoutController">
        <div class="checkout-grid">
            <!-- Left Column: Booking Details -->
            <div>
                <div class="checkout-section">
                    <h3 class="section-title">Booking Details</h3>
                    
                    <div class="form-group">
                        <label>Booking Date *</label>
                        <input type="date" name="booking_date" required 
                               min="<%= java.time.LocalDate.now() %>">
                    </div>
                    
                    <div class="form-group">
                        <label>Preferred Time *</label>
                        <input type="time" name="booking_time" required 
                               min="09:00" max="18:00">
                    </div>
                    
                    <div class="form-group">
                        <label>Special Requests</label>
                        <textarea name="special_requests" rows="4" 
                                  placeholder="Any special requirements or notes..."></textarea>
                    </div>
                </div>
                
                <div class="checkout-section" style="margin-top: 20px;">
                    <h3 class="section-title">Payment Method</h3>
                    
                    <div class="payment-options">
                        <label class="payment-option">
                            <input type="radio" name="payment_method" value="online" checked>
                            Online Payment
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="payment_method" value="cash">
                            Cash on Service
                        </label>
                    </div>
                </div>
            </div>
            
            <!-- Right Column: Order Summary -->
            <div>
                <div class="checkout-section">
                    <h3 class="section-title">Order Summary</h3>
                    
                    <% if (cartItems != null) {
                        for (CartItem item : cartItems) { %>
                            <div class="cart-item">
                                <div>
                                    <strong><%= item.getServiceName() %></strong>
                                    <br>
                                    <small>Qty: <%= item.getQuantity() %> × $<%= String.format("%.2f", item.getServicePrice()) %></small>
                                </div>
                                <div>
                                    $<%= String.format("%.2f", item.getSubtotal()) %>
                                </div>
                            </div>
                        <% }
                    } %>
                    
                    <div class="order-summary">
                        <div class="summary-row">
                            <span>Subtotal:</span>
                            <span>$<%= String.format("%.2f", cartTotal) %></span>
                        </div>
                        <div class="summary-row">
                            <span>GST (8%):</span>
                            <span>$<%= String.format("%.2f", gst) %></span>
                        </div>
                        <div class="summary-row">
                            <span>Total:</span>
                            <span>$<%= String.format("%.2f", totalWithGST) %></span>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-submit">Complete Booking</button>
                    
                    <p style="text-align: center; margin-top: 15px; color: #7f8c8d;">
                        <small>
                            <a href="${pageContext.request.contextPath}/ViewCartController">← Back to Cart</a>
                        </small>
                    </p>
                </div>
            </div>
        </div>
    </form>
</div>

<%@ include file="/includes/footer.jsp" %>