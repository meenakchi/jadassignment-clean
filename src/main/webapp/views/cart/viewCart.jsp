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
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    
    if(cartTotal == null) cartTotal = BigDecimal.ZERO;
    if(gst == null) gst = BigDecimal.ZERO;
    if(totalWithGST == null) totalWithGST = BigDecimal.ZERO;
    if(itemCount == null) itemCount = 0;
%>

<style>
    .cart-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    }
    .cart-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #3498db;
    }
    .cart-header h2 {
        color: #2c3e50;
        margin-bottom: 5px;
    }
    .cart-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
    }
    .cart-table th {
        background-color: #3498db;
        color: white;
        padding: 15px;
        text-align: left;
        font-weight: 600;
    }
    .cart-table td {
        padding: 15px;
        border-bottom: 1px solid #ecf0f1;
    }
    .cart-table tr:hover {
        background-color: #f8f9fa;
    }
    .btn-remove {
        background-color: #e74c3c;
        color: white;
        padding: 8px 16px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
    }
    .btn-remove:hover {
        background-color: #c0392b;
    }
    .cart-summary {
        background-color: #f8f9fa;
        padding: 25px;
        border-radius: 8px;
        margin-bottom: 20px;
        max-width: 400px;
        margin-left: auto;
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
    .action-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
    }
    .btn-checkout {
        background-color: #27ae60;
        color: white;
        padding: 15px 40px;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
    }
    .btn-checkout:hover {
        background-color: #229954;
    }
    .btn-continue {
        background-color: #3498db;
        color: white;
        padding: 15px 40px;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
    }
    .btn-continue:hover {
        background-color: #2980b9;
    }
    .empty-cart {
        text-align: center;
        padding: 60px 20px;
        color: #7f8c8d;
    }
    .qty-input {
        width: 60px;
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
        text-align: center;
    }
</style>

<div class="cart-container">
    <div class="cart-header">
        <h2>Shopping Cart</h2>
        <p style="color: #7f8c8d; margin: 5px 0 0 0;"><%= itemCount %> item(s) in your cart</p>
    </div>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="empty-cart">
            <h3>Your cart is empty</h3>
            <p>Browse our services and add items to your cart.</p>
            <a href="${pageContext.request.contextPath}/ServicesController" class="btn-continue">Browse Services</a>
        </div>
    <% } else { %>
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Service</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Action</th>
                </tr>
                </thead>
            <tbody>
                <% for (CartItem item : cartItems) { %>
                    <tr>
                        <td><%= item.getServiceName() %></td>
                        <td>$<%= String.format("%.2f", item.getServicePrice()) %></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/UpdateCartController" style="display: inline;">
                                <input type="hidden" name="cart_id" value="<%= item.getCartId() %>">
                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                       min="1" max="10" class="qty-input"
                                       onchange="this.form.submit()">
                            </form>
                        </td>
                        <td>$<%= String.format("%.2f", item.getSubtotal()) %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/RemoveFromCartController?cart_id=<%= item.getCartId() %>" 
                               class="btn-remove"
                               onclick="return confirm('Remove this item from cart?')">
                                Remove
                            </a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div class="cart-summary">
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

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/ServicesController" class="btn-continue">Continue Shopping</a>
            <a href="${pageContext.request.contextPath}/CheckoutController" class="btn-checkout">Proceed to Checkout</a>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>