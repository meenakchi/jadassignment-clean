<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.BookingDetail" %>
<%@ page import="java.util.List" %>
<%@ include file="/includes/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
        return;
    }
%>

<style>
    .feedback-container {
        max-width: 700px;
        margin: 40px auto;
        padding: 30px;
    }
    .feedback-card {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    .feedback-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #3498db;
    }
    .feedback-header h2 {
        color: #2c3e50;
        margin-bottom: 10px;
    }
    .booking-info {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 30px;
    }
    .info-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #e0e0e0;
    }
    .info-row:last-child {
        border-bottom: none;
    }
    .form-group {
        margin-bottom: 25px;
    }
    .form-group label {
        display: block;
        margin-bottom: 10px;
        font-weight: 600;
        color: #2c3e50;
        font-size: 1.1rem;
    }
    .rating-group {
        display: flex;
        gap: 15px;
        margin-top: 10px;
    }
    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
        gap: 5px;
    }
    .star-rating input {
        display: none;
    }
    .star-rating label {
        cursor: pointer;
        font-size: 2rem;
        color: #ddd;
        transition: color 0.2s;
    }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: #f39c12;
    }
    textarea {
        width: 100%;
        padding: 15px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 1rem;
        font-family: inherit;
        resize: vertical;
        min-height: 150px;
        transition: border-color 0.3s;
    }
    textarea:focus {
        border-color: #3498db;
        outline: none;
    }
    .btn-submit {
        width: 100%;
        background-color: #27ae60;
        color: white;
        padding: 15px;
        border: none;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .btn-submit:hover {
        background-color: #229954;
    }
    .back-link {
        text-align: center;
        margin-top: 20px;
    }
    .back-link a {
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
    }
    .back-link a:hover {
        text-decoration: underline;
    }
    .required {
        color: #e74c3c;
    }
</style>

<div class="feedback-container">
    <div class="feedback-card">
        <div class="feedback-header">
            <h2>Submit Feedback</h2>
            <p style="color: #7f8c8d;">Share your experience with us</p>
        </div>

        <div class="booking-info">
            <h3 style="margin-top: 0;">Booking Details</h3>
            <div class="info-row">
                <span><strong>Booking ID:</strong></span>
                <span>#<%= booking.getBookingId() %></span>
            </div>
            <div class="info-row">
                <span><strong>Date:</strong></span>
                <span><%= booking.getBookingDate() %></span>
            </div>
            <div class="info-row">
                <span><strong>Status:</strong></span>
                <span style="color: #27ae60; font-weight: 600;"><%= booking.getStatus() %></span>
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/SubmitFeedbackController">
            <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
            
            <div class="form-group">
                <label>
                    How would you rate our service? <span class="required">*</span>
                </label>
                <div class="star-rating">
                    <input type="radio" name="rating" value="5" id="star5" required>
                    <label for="star5">★</label>
                    <input type="radio" name="rating" value="4" id="star4">
                    <label for="star4">★</label>
                    <input type="radio" name="rating" value="3" id="star3">
                    <label for="star3">★</label>
                    <input type="radio" name="rating" value="2" id="star2">
                    <label for="star2">★</label>
                    <input type="radio" name="rating" value="1" id="star1">
                    <label for="star1">★</label>
                </div>
            </div>

            <div class="form-group">
                <label for="comments">
                    Your Comments <span class="required">*</span>
                </label>
                <textarea 
                    name="comments" 
                    id="comments"
                    placeholder="Tell us about your experience with our service..."
                    required
                ></textarea>
            </div>

            <button type="submit" class="btn-submit">Submit Feedback</button>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/BookingHistoryController">
                    ← Back to Booking History
                </a>
            </div>
        </form>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>