<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Feedback" %>
<%@ include file="/includes/header.jsp" %>

<%
    // This page can be accessed by both members (their own feedback) and admins (all feedback)
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Feedback";
    
    Boolean isAdmin = (Boolean) session.getAttribute("admin_id");
    if (isAdmin == null) isAdmin = false;
%>

<style>
    .feedback-container {
        max-width: 1200px;
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
    .feedback-grid {
        display: grid;
        gap: 20px;
    }
    .feedback-card {
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }
    .feedback-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }
    .feedback-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 15px;
        border-bottom: 2px solid #ecf0f1;
    }
    .service-name {
        font-size: 1.3rem;
        font-weight: 600;
        color: #2c3e50;
    }
    .rating-stars {
        color: #f39c12;
        font-size: 1.5rem;
    }
    .member-info {
        color: #7f8c8d;
        font-size: 0.95rem;
        margin-bottom: 15px;
    }
    .feedback-comment {
        color: #2c3e50;
        line-height: 1.6;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 5px;
        border-left: 4px solid #3498db;
    }
    .feedback-date {
        color: #95a5a6;
        font-size: 0.85rem;
        margin-top: 10px;
        text-align: right;
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
    .back-link {
        display: inline-block;
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
        margin-bottom: 20px;
    }
    .back-link:hover {
        text-decoration: underline;
    }
</style>

<div class="feedback-container">
    <% if (isAdmin) { %>
        <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/MemberDashboardController" class="back-link">← Back to Dashboard</a>
    <% } %>
    
    <div class="page-header">
        <h2><%= pageTitle %></h2>
        <p style="color: #7f8c8d;">Customer reviews and ratings</p>
    </div>
    
    <% if (feedbackList == null || feedbackList.isEmpty()) { %>
        <div class="empty-state">
            <h3>No feedback yet</h3>
            <p style="color: #95a5a6; margin-bottom: 25px;">
                <% if (!isAdmin) { %>
                    Complete a booking to leave feedback!
                <% } else { %>
                    No customers have submitted feedback yet.
                <% } %>
            </p>
            <% if (!isAdmin) { %>
                <a href="${pageContext.request.contextPath}/ServicesController" class="btn-primary" style="padding: 12px 30px; text-decoration: none; border-radius: 5px;">
                    Browse Services
                </a>
            <% } %>
        </div>
    <% } else { %>
        <div class="feedback-grid">
            <% for (Feedback feedback : feedbackList) { %>
                <div class="feedback-card">
                    <div class="feedback-header">
                        <div class="service-name"><%= feedback.getServiceName() %></div>
                        <div class="rating-stars">
                            <% 
                                int rating = feedback.getRating();
                                for (int i = 1; i <= 5; i++) {
                                    out.print(i <= rating ? "★" : "☆");
                                }
                            %>
                        </div>
                    </div>
                    
                    <div class="member-info">
                        <strong>By:</strong> <%= feedback.getMemberName() %>
                        <% if (isAdmin) { %>
                            | <strong>Booking ID:</strong> #<%= feedback.getBookingId() %>
                        <% } %>
                    </div>
                    
                    <div class="feedback-comment">
                        "<%= feedback.getComments() %>"
                    </div>
                    
                    <div class="feedback-date">
                        <%= String.format("%1$tB %1$te, %1$tY at %1$tI:%1$tM %1$Tp", feedback.getCreatedAt()) %>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>