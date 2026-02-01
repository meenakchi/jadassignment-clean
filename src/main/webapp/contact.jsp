<%@ include file="includes/header.jsp" %>

<style>
    .contact-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
    }
    .contact-hero {
        text-align: center;
        margin-bottom: 50px;
    }
    .contact-hero h1 {
        font-size: 2.5rem;
        color: #2c3e50;
        margin-bottom: 15px;
    }
    .contact-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 40px;
        margin-top: 40px;
    }
    .contact-info-card {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .contact-info-card h3 {
        color: #3498db;
        margin-bottom: 20px;
        font-size: 1.5rem;
    }
    .info-item {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    .info-icon {
        font-size: 1.5rem;
        margin-right: 15px;
        color: #3498db;
    }
    .info-text h4 {
        margin: 0 0 5px 0;
        color: #2c3e50;
        font-size: 1rem;
    }
    .info-text p {
        margin: 0;
        color: #7f8c8d;
    }
    .contact-form-card {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .contact-form-card h3 {
        color: #2c3e50;
        margin-bottom: 25px;
        font-size: 1.5rem;
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
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 1rem;
        transition: border-color 0.3s;
    }
    .form-group input:focus,
    .form-group textarea:focus,
    .form-group select:focus {
        border-color: #3498db;
        outline: none;
    }
    .form-group textarea {
        resize: vertical;
        min-height: 120px;
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
    .map-container {
        width: 100%;
        height: 300px;
        background: #f0f0f0;
        border-radius: 10px;
        margin-top: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #7f8c8d;
    }
</style>

<div class="contact-container">
    <div class="contact-hero">
        <h1>Contact Us</h1>
        <p style="color: #7f8c8d; font-size: 1.1rem;">We'd love to hear from you. Get in touch with our team.</p>
    </div>

    <div class="contact-grid">
        <div>
            <div class="contact-info-card">
                <h3>Get In Touch</h3>
                
                <div class="info-item">
                    <div class="info-icon">📍</div>
                    <div class="info-text">
                        <h4>Address</h4>
                        <p>123 Care Street, Singapore 123456</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">📞</div>
                    <div class="info-text">
                        <h4>Phone</h4>
                        <p>+65 1234 5678</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">📧</div>
                    <div class="info-text">
                        <h4>Email</h4>
                        <p>info@silvercare.com</p>
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-icon">🕐</div>
                    <div class="info-text">
                        <h4>Business Hours</h4>
                        <p>Mon - Fri: 9:00 AM - 6:00 PM<br>
                           Sat: 9:00 AM - 2:00 PM<br>
                           Sun: Closed</p>
                    </div>
                </div>
            </div>
        </div>

        <div>
            <div class="contact-form-card">
                <h3>Send Us a Message</h3>
                <form action="#" method="post">
                    <div class="form-group">
                        <label>Your Name *</label>
                        <input type="text" name="name" required>
                    </div>

                    <div class="form-group">
                        <label>Email Address *</label>
                        <input type="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" name="phone">
                    </div>

                    <div class="form-group">
                        <label>Subject *</label>
                        <select name="subject" required>
                            <option value="">Select a subject</option>
                            <option value="general">General Inquiry</option>
                            <option value="booking">Booking Question</option>
                            <option value="feedback">Feedback</option>
                            <option value="complaint">Complaint</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Message *</label>
                        <textarea name="message" required placeholder="How can we help you?"></textarea>
                    </div>

                    <button type="submit" class="btn-submit">Send Message</button>
                </form>
            </div>
        </div>
    </div>

    <div class="map-container">
        <p>Map Location: 123 Care Street, Singapore</p>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>