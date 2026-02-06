<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Feedback" %>
<%@ include file="/includes/header.jsp" %>

<%
    Service service = (Service) request.getAttribute("service");
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    Double avgRating = (Double) request.getAttribute("avgRating");
    
    if(service == null) {
        response.sendRedirect(request.getContextPath() + "/ServicesController");
        return;
    }
    
    // FIXED: Proper image path handling
    String imageUrl = service.getImageUrl();
    if(imageUrl != null && !imageUrl.isEmpty()) {
        // Remove leading slash if present
        if(imageUrl.startsWith("/")) {
            imageUrl = imageUrl.substring(1);
        }
    } else {
        // Default fallback image
        imageUrl = "images/default-service.jpg";
    }
%>

<style>
.service-details-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 1rem;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.breadcrumb {
    margin-bottom: 2rem;
    font-size: 0.9rem;
    color: #666;
}

.breadcrumb a {
    color: #007bff;
    text-decoration: none;
}

.breadcrumb a:hover {
    text-decoration: underline;
}

.service-detail-card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    overflow: hidden;
    margin-bottom: 2rem;
}

.service-detail-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 3rem;
    padding: 2.5rem;
}

@media (max-width: 768px) {
    .service-detail-grid {
        grid-template-columns: 1fr;
        gap: 2rem;
        padding: 1.5rem;
    }
}

.service-image-section {
    position: relative;
}

.service-image-section img {
    width: 100%;
    height: 300px;
    object-fit: cover;
    border-radius: 12px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.service-info-section {
    padding-left: 1.5rem;
}

.category-badge {
    display: inline-block;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 0.4rem 1rem;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 600;
    margin-bottom: 1rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.service-title {
    font-size: 2.2rem;
    font-weight: 700;
    color: #1a1a1a;
    margin: 0 0 1rem 0;
    line-height: 1.2;
}

.service-description {
    font-size: 1.1rem;
    color: #555;
    line-height: 1.7;
    margin-bottom: 2rem;
}

.service-meta-info {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-bottom: 2rem;
}

.meta-item {
    display: flex;
    flex-direction: column;
}

.meta-label {
    font-size: 0.9rem;
    color: #666;
    font-weight: 500;
    margin-bottom: 0.25rem;
}

.meta-value {
    font-size: 1.4rem;
    font-weight: 700;
    color: #1a1a1a;
}

.price-highlight {
    color: #e74c3c !important;
    font-size: 1.6rem !important;
}

.service-features {
    margin-bottom: 2.5rem;
}

.features-title {
    font-size: 1.3rem;
    font-weight: 600;
    color: #1a1a1a;
    margin-bottom: 1rem;
}

.features-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.features-list li {
    padding: 0.75rem 0;
    padding-left: 2rem;
    position: relative;
    color: #444;
    font-size: 1rem;
}

.features-list li::before {
    content: "✓";
    position: absolute;
    left: 0;
    color: #28a745;
    font-weight: bold;
    font-size: 1.1rem;
}

.action-buttons {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
}

.btn-back, .btn-book {
    padding: 1rem 2rem;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    text-decoration: none;
    text-align: center;
    transition: all 0.3s ease;
    display: inline-block;
    min-width: 160px;
}

.btn-back {
    background: #6c757d;
    color: white;
    border: 2px solid #6c757d;
}

.btn-back:hover {
    background: #5a6268;
    border-color: #5a6268;
    transform: translateY(-2px);
}

.btn-book {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white;
    border: 2px solid #007bff;
}

.btn-book:hover {
    background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
    border-color: #0056b3;
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0,123,255,0.3);
}

.btn-book[onclick*="alert"] {
    background: #6c757d !important;
    border-color: #6c757d !important;
    cursor: not-allowed;
}

.btn-book[onclick*="alert"]:hover {
    background: #5a6268 !important;
    transform: none !important;
    box-shadow: none !important;
}
</style>

<div class="service-details-container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <span>›</span>
        <a href="${pageContext.request.contextPath}/ServicesController">Services</a>
        <span>›</span>
        <span><%= service.getServiceName() %></span>
    </div>
    
    <div class="service-detail-card">
        <div class="service-detail-grid">
            <div class="service-image-section">
                <img src="<%= request.getContextPath() %>/<%= imageUrl %>" 
                     alt="<%= service.getServiceName() %>" 
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/default-service.jpg'">
            </div>
            
            <div class="service-info-section">
                <span class="category-badge"><%= service.getCategoryName() %></span>
                
                <h1 class="service-title"><%= service.getServiceName() %></h1>
                
                <p class="service-description">
                    <%= service.getDescription() != null && !service.getDescription().isEmpty() ? 
                        service.getDescription() : 
                        "Professional elderly care service tailored to meet your specific needs. Our experienced caregivers provide compassionate and reliable support." %>
                </p>
                
                <div class="service-meta-info">
                    <div class="meta-item">
                        <span class="meta-label">Price</span>
                        <span class="meta-value price-highlight">$<%= String.format("%.2f", service.getPrice()) %>/hour</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Duration</span>
                        <span class="meta-value"><%= service.getDuration() %> minutes</span>
                    </div>
                </div>
                
                <div class="service-features">
                    <h3 class="features-title">What's Included:</h3>
                    <ul class="features-list">
                        <li>Professional and trained caregivers</li>
                        <li>Flexible scheduling options</li>
                        <li>Personalized care plan</li>
                        <li>Regular progress updates</li>
                        <li>24/7 customer support</li>
                    </ul>
                </div>
                
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/ServicesController" class="btn-back">← Back to Services</a>
                    <%
                        Integer loggedInMemberId = (Integer) session.getAttribute("member_id");
                        if(loggedInMemberId != null && service.isActive()) {
                    %>
                        <a href="${pageContext.request.contextPath}/AddToCartController?service_id=<%= service.getServiceId() %>" class="btn-book">
                            Add to Cart
                        </a>
                    <% } else if(loggedInMemberId != null) { %>
                        <a href="#" class="btn-book" onclick="alert('This service is currently unavailable'); return false;">
                            Currently Unavailable
                        </a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/MemberLoginController" class="btn-book">Login to Book</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>
