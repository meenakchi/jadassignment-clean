<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Service" %>
<%@ page import="model.ServiceCategory" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<ServiceCategory> categories = (List<ServiceCategory>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    
    if(services == null) services = new ArrayList<>();
    if(categories == null) categories = new ArrayList<>();
%>

<div class="services-container">
    <div class="page-header">
        <h1>Our care services</h1>
        <p style="color:red;">${errorMessage}</p>
        <p>Let our care givers provide and help with all your care giving and housekeeping needs</p>
    </div>

    <div class="filter-section">
        <div class="filter-label">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/>
            </svg>
            Filter:
        </div>
        <div class="filter-buttons">
            <button class="filter-btn <%= (selectedCategory == null || selectedCategory.equals("all")) ? "active" : "" %>"
                    onclick="window.location.href='${pageContext.request.contextPath}/ServicesController?category=all'">
                All
            </button>
            <%
                for(ServiceCategory category : categories) {
                    String catId = String.valueOf(category.getCategoryId());
                    boolean isActive = catId.equals(selectedCategory);
            %>
                <button class="filter-btn <%= isActive ? "active" : "" %>"
                        onclick="window.location.href='${pageContext.request.contextPath}/ServicesController?category=<%= catId %>'">
                    <%= category.getCategoryName() %>
                </button>
            <%
                }
            %>
        </div>
    </div>

    <% if(services.isEmpty()) { %>
        <div class="no-services">
            <div class="no-services-icon">🔍</div>
            <h2>No services found</h2>
            <p>Try selecting a different category</p>
        </div>
    <% } else { %>
        <div class="services-grid">
            <% for(Service service : services) {
                String imageUrl = service.getImageUrl();
                boolean isAvailable = service.isActive();
                if(imageUrl != null && imageUrl.startsWith("/")) {
                    imageUrl = imageUrl.substring(1);
                }
                if(imageUrl == null || imageUrl.isEmpty()) {
                    imageUrl = "images/homepageimg.jpeg";
                }
            %>
                <div class="service-card <%= !isAvailable ? "unavailable" : "" %>">
                    <span class="availability-badge <%= isAvailable ? "badge-available" : "badge-unavailable" %>">
                        <%= isAvailable ? "Available" : "Fully Booked" %>
                    </span>
                    
                    <img src="<%= imageUrl %>"
                         alt="<%= service.getServiceName() %>"
                         class="service-image"
                         onerror="this.src='images/homepageimg.jpeg'">
                    <div class="service-content">
                        <span class="service-category-badge">
                            <%= service.getCategoryName() %>
                        </span>
                        <h3 class="service-name"><%= service.getServiceName() %></h3>
                        <p class="service-description">
                            <%= service.getDescription() != null ? service.getDescription() : "Professional care service tailored to your needs." %>
                        </p>
                        <div class="service-meta">
                            <div>
                                <div class="service-price">
                                    $<%= service.getPrice() %><span class="service-price-label">/H</span>
                                </div>
                                <% if(service.getDuration() > 0) { %>
                                    <div class="service-duration">
                                        Duration: <%= service.getDuration() %> mins
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/ServiceDetailsController?id=<%= service.getServiceId() %>" class="details-btn">
                            <%= isAvailable ? "Details" : "View Details" %>
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
