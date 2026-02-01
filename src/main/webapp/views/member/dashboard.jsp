<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Member" %>
<%@ include file="/includes/header.jsp" %>

<%
    Member member = (Member) request.getAttribute("member");
    if(member == null) {
        response.sendRedirect(request.getContextPath() + "/MemberLoginController");
        return;
    }
%>

<style>
    .dashboard-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .welcome-section {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 40px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    .dashboard-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 25px;
        margin-bottom: 30px;
    }
    .dashboard-card {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }
    .dashboard-card:hover {
        transform: translateY(-5px);
    }
    .card-icon {
        font-size: 3rem;
        margin-bottom: 15px;
    }
    .card-title {
        font-size: 1.3rem;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    .card-desc {
        color: #7f8c8d;
        margin-bottom: 20px;
    }
    .card-btn {
        background: #3498db;
        color: white;
        padding: 12px 24px;
        border-radius: 5px;
        text-decoration: none;
        display: inline-block;
        font-weight: 600;
        transition: background 0.3s;
    }
    .card-btn:hover {
        background: #2980b9;
    }
    .profile-section {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .profile-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin-top: 20px;
    }
    .profile-item {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 5px;
    }
    .profile-label {
        font-size: 0.9rem;
        color: #7f8c8d;
        margin-bottom: 5px;
    }
    .profile-value {
        font-size: 1.1rem;
        color: #2c3e50;
        font-weight: 600;
    }
    .edit-profile-btn {
        background: #27ae60;
        color: white;
        padding: 12px 30px;
        border-radius: 5px;
        text-decoration: none;
        display: inline-block;
        margin-top: 20px;
        font-weight: 600;
    }
</style>

<div class="dashboard-container">
    <div class="welcome-section">
        <h1>Welcome back, <%= member.getFullName() %>!</h1>
        <p style="opacity: 0.9; margin-top: 10px;">Manage your bookings, profile, and explore our services</p>
    </div>

    <div class="dashboard-grid">
        <div class="dashboard-card">
            <div class="card-icon">📅</div>
            <div class="card-title">My Bookings</div>
            <div class="card-desc">View and manage your service bookings</div>
            <a href="${pageContext.request.contextPath}/BookingHistoryController" class="card-btn">View Bookings</a>
        </div>

        <div class="dashboard-card">
            <div class="card-icon">🛒</div>
            <div class="card-title">Shopping Cart</div>
            <div class="card-desc">Review items in your cart</div>
            <a href="${pageContext.request.contextPath}/ViewCartController" class="card-btn">View Cart</a>
        </div>

        <div class="dashboard-card">
            <div class="card-icon">🏥</div>
            <div class="card-title">Browse Services</div>
            <div class="card-desc">Explore our care services</div>
            <a href="${pageContext.request.contextPath}/ServicesController" class="card-btn">Browse</a>
        </div>

        <div class="dashboard-card">
            <div class="card-icon">💬</div>
            <div class="card-title">My Feedback</div>
            <div class="card-desc">View your reviews and ratings</div>
            <a href="${pageContext.request.contextPath}/ViewFeedbackController" class="card-btn">View Feedback</a>
        </div>
    </div>

    <div class="profile-section">
        <h2 style="margin-bottom: 20px;">My Profile</h2>
        
        <div class="profile-grid">
            <div class="profile-item">
                <div class="profile-label">Full Name</div>
                <div class="profile-value"><%= member.getFullName() %></div>
            </div>
            
            <div class="profile-item">
                <div class="profile-label">Email</div>
                <div class="profile-value"><%= member.getEmail() %></div>
            </div>
            
            <div class="profile-item">
                <div class="profile-label">Phone</div>
                <div class="profile-value"><%= member.getPhone() != null ? member.getPhone() : "Not provided" %></div>
            </div>
            
            <div class="profile-item">
                <div class="profile-label">Address</div>
                <div class="profile-value"><%= member.getAddress() != null ? member.getAddress() : "Not provided" %></div>
            </div>
        </div>

        <a href="#" class="edit-profile-btn" onclick="showEditForm(); return false;">Edit Profile</a>
        
        <div id="editForm" style="display: none; margin-top: 30px; padding: 25px; background: #f8f9fa; border-radius: 8px;">
            <h3>Update Profile</h3>
            <form method="post" action="${pageContext.request.contextPath}/UpdateProfileController">
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 600;">Full Name</label>
                    <input type="text" name="full_name" value="<%= member.getFullName() %>" 
                           required style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 5px;">
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 600;">Email</label>
                    <input type="email" name="email" value="<%= member.getEmail() %>" 
                           required style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 5px;">
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 600;">Phone</label>
                    <input type="tel" name="phone" value="<%= member.getPhone() != null ? member.getPhone() : "" %>" 
                           style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 5px;">
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 600;">Address</label>
                    <textarea name="address" rows="3" 
                              style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 5px;"><%= member.getAddress() != null ? member.getAddress() : "" %></textarea>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 600;">Date of Birth</label>
                    <input type="date" name="dob" value="<%= member.getDateOfBirth() != null ? member.getDateOfBirth() : "" %>" 
                           style="width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 5px;">
                </div>
                
                <button type="submit" style="background: #27ae60; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-weight: 600; cursor: pointer;">
                    Save Changes
                </button>
                <button type="button" onclick="hideEditForm()" style="background: #95a5a6; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-weight: 600; cursor: pointer; margin-left: 10px;">
                    Cancel
                </button>
            </form>
        </div>
    </div>
</div>

<script>
function showEditForm() {
    document.getElementById('editForm').style.display = 'block';
}
function hideEditForm() {
    document.getElementById('editForm').style.display = 'none';
}
</script>

<%@ include file="/includes/footer.jsp" %>