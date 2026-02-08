<%@ include file="includes/header.jsp" %>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-text">
            <h1>Professional care for elderly</h1>
            <p>Trusted elderly care services in Singapore</p>
            <a href="services.jsp" class="btn-primary">Book a service now!</a>
        </div>
        <div class="hero-image">
            <img src="images/homepageimg.jpg" alt="Elderly care">
        </div>
    </div>
</section>

<!-- Services Section -->
<section class="services-section">
    <div class="container">
        <h2>Our care services</h2>
        <div class="services-grid">
            <div class="service-card">
                <img src="images/health-care.jpg" alt="In-home care">
                <h3>In-home care</h3>
                <p>Professional care services in the comfort of your home</p>
                <a href="services.jsp?category=1" class="btn-secondary">View Services</a>
            </div>
            <div class="service-card">
                <img src="images/assisted-living.jpg" alt="Assisted living">
                <h3>Assisted living care</h3>
                <p>Daily living assistance and support services</p>
                <a href="services.jsp?category=2" class="btn-secondary">View Services</a>
            </div>
            <div class="service-card">
                <img src="images/treatment.jpg" alt="Specialized care">
                <h3>Specialized care</h3>
                <p>Expert care for specific medical conditions</p>
                <a href="services.jsp?category=3" class="btn-secondary">View Services</a>
            </div>
        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
