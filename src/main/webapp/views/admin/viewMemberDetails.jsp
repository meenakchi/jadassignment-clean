<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.List" %>
<%@ include file="/includes/header.jsp" %>

<%
    // Check admin session
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect(request.getContextPath() + "/AdminLoginController");
        return;
    }
    
    Member member = (Member) request.getAttribute("member");
    MemberMedicalInfo medicalInfo = (MemberMedicalInfo) request.getAttribute("medicalInfo");
    List emergencyContacts = (List) request.getAttribute("emergencyContacts");
%>

<style>
    .member-details-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .detail-section {
        background: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .section-header {
        background: #3498db;
        color: white;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .section-header h3 {
        margin: 0;
    }
    .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
    }
    .info-item {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 5px;
    }
    .info-label {
        font-size: 0.9rem;
        color: #7f8c8d;
        font-weight: 600;
        margin-bottom: 5px;
    }
    .info-value {
        font-size: 1.1rem;
        color: #2c3e50;
    }
    .contact-card {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 10px;
        border-left: 4px solid #3498db;
    }
    .primary-badge {
        background: #27ae60;
        color: white;
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 0.8rem;
        margin-left: 10px;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
    }
    .back-link:hover {
        text-decoration: underline;
    }
</style>

<div class="member-details-container">
    <a href="${pageContext.request.contextPath}/ManageMembersController" class="back-link">← Back to Members</a>
    
    <% if (member != null) { %>
        <h2 style="margin: 20px 0;">Client Profile</h2>
        
        <!-- Basic Information -->
        <div class="detail-section">
            <div class="section-header">
                <h3>Basic Information</h3>
            </div>
            
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Full Name</div>
                    <div class="info-value"><%= member.getFullName() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Username</div>
                    <div class="info-value"><%= member.getUsername() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Email</div>
                    <div class="info-value"><%= member.getEmail() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Phone</div>
                    <div class="info-value"><%= member.getPhone() != null ? member.getPhone() : "Not provided" %></div>
                </div>
                <div class="info-item" style="grid-column: span 2;">
                    <div class="info-label">Address</div>
                    <div class="info-value"><%= member.getAddress() != null ? member.getAddress() : "Not provided" %></div>
                </div>
                <% if (member.getDateOfBirth() != null) { %>
                    <div class="info-item">
                        <div class="info-label">Date of Birth</div>
                        <div class="info-value"><%= member.getDateOfBirth() %></div>
                    </div>
                <% } %>
                <div class="info-item">
                    <div class="info-label">Member Since</div>
                    <div class="info-value"><%= String.format("%1$tB %1$te, %1$tY", member.getCreatedAt()) %></div>
                </div>
            </div>
        </div>
        
        <!-- Medical Information -->
        <div class="detail-section">
            <div class="section-header">
                <h3>Medical Information</h3>
            </div>
            
            <% if (medicalInfo != null) { %>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Blood Type</div>
                        <div class="info-value"><%= medicalInfo.getBloodType() != null ? medicalInfo.getBloodType() : "Not specified" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Mobility Status</div>
                        <div class="info-value"><%= medicalInfo.getMobilityStatus() != null ? medicalInfo.getMobilityStatus() : "Not specified" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Allergies</div>
                        <div class="info-value"><%= medicalInfo.getAllergies() != null ? medicalInfo.getAllergies() : "None recorded" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Current Medications</div>
                        <div class="info-value"><%= medicalInfo.getMedications() != null ? medicalInfo.getMedications() : "None recorded" %></div>
                    </div>
                    <div class="info-item" style="grid-column: span 2;">
                        <div class="info-label">Medical Conditions</div>
                        <div class="info-value"><%= medicalInfo.getMedicalConditions() != null ? medicalInfo.getMedicalConditions() : "None recorded" %></div>
                    </div>
                    <div class="info-item" style="grid-column: span 2;">
                        <div class="info-label">Dietary Restrictions</div>
                        <div class="info-value"><%= medicalInfo.getDietaryRestrictions() != null ? medicalInfo.getDietaryRestrictions() : "None recorded" %></div>
                    </div>
                </div>
            <% } else { %>
                <p style="color: #7f8c8d;">No medical information recorded.</p>
            <% } %>
        </div>
        
        <!-- Emergency Contacts -->
        <div class="detail-section">
            <div class="section-header">
                <h3>Emergency Contacts</h3>
            </div>
            
            <% if (emergencyContacts != null && !emergencyContacts.isEmpty()) { %>
                <% for (Object obj : emergencyContacts) { 
                    EmergencyContact contact = (EmergencyContact) obj;
                %>
                    <div class="contact-card">
                        <strong><%= contact.getContactName() %></strong>
                        <% if (contact.isPrimary()) { %>
                            <span class="primary-badge">PRIMARY</span>
                        <% } %>
                        <br>
                        <small>Relationship: <%= contact.getRelationship() %></small><br>
                        <small>Phone: <%= contact.getPhone() %></small><br>
                        <% if (contact.getEmail() != null && !contact.getEmail().isEmpty()) { %>
                            <small>Email: <%= contact.getEmail() %></small><br>
                        <% } %>
                        <% if (contact.getAddress() != null && !contact.getAddress().isEmpty()) { %>
                            <small>Address: <%= contact.getAddress() %></small>
                        <% } %>
                    </div>
                <% } %>
            <% } else { %>
                <p style="color: #7f8c8d;">No emergency contacts recorded.</p>
            <% } %>
        </div>
        
    <% } else { %>
        <div class="detail-section" style="text-align: center; padding: 60px;">
            <h3>Member Not Found</h3>
            <p style="color: #7f8c8d;">The member you're looking for doesn't exist.</p>
            <a href="${pageContext.request.contextPath}/ManageMembersController" class="back-link">← Back to Members</a>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
