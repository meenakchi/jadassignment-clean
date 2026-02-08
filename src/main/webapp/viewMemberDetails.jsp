
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*" %>
<%@ page import="java.util.List" %>
<%@ include file="/includes/header.jsp" %>

<%
    Member member = (Member) request.getAttribute("member");
    MemberMedicalInfo medicalInfo = (MemberMedicalInfo) request.getAttribute("medicalInfo");
    List<EmergencyContact> emergencyContacts = (List<EmergencyContact>) request.getAttribute("emergencyContacts");
    List<MemberCareNeed> careNeeds = (List<MemberCareNeed>) request.getAttribute("careNeeds");
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
    .btn-edit {
        background: #f39c12;
        color: white;
        padding: 8px 16px;
        border-radius: 5px;
        text-decoration: none;
        font-weight: 600;
    }
</style>

<div class="member-details-container">
    <a href="${pageContext.request.contextPath}/ManageMembersController" class="back-link">← Back to Members</a>
    
    <h2 style="margin: 20px 0;">Client Profile</h2>
    
    <!-- Basic Information -->
    <div class="detail-section">
        <div class="section-header">
            <h3 style="margin: 0;">Basic Information</h3>
            <a href="editMember.jsp?id=<%= member.getMemberId() %>" class="btn-edit">Edit</a>
        </div>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Full Name</div>
                <div class="info-value"><%= member.getFullName() %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Email</div>
                <div class="info-value"><%= member.getEmail() %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Phone</div>
                <div class="info-value"><%= member.getPhone() != null ? member.getPhone() : "Not provided" %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Address</div>
                <div class="info-value"><%= member.getAddress() != null ? member.getAddress() : "Not provided" %></div>
            </div>
        </div>
    </div>
    
    <!-- Medical Information -->
    <div class="detail-section">
        <div class="section-header">
            <h3 style="margin: 0;">Medical Information</h3>
            <a href="editMedicalInfo.jsp?member_id=<%= member.getMemberId() %>" class="btn-edit">Edit</a>
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
            </div>
        <% } else { %>
            <p style="color: #7f8c8d;">No medical information recorded. <a href="editMedicalInfo.jsp?member_id=<%= member.getMemberId() %>">Add medical information</a></p>
        <% } %>
    </div>
    
    <!-- Emergency Contacts -->
    <div class="detail-section">
        <div class="section-header">
            <h3 style="margin: 0;">Emergency Contacts</h3>
            <a href="addEmergencyContact.jsp?member_id=<%= member.getMemberId() %>" class="btn-edit">Add Contact</a>
        </div>
        
        <% if (emergencyContacts != null && !emergencyContacts.isEmpty()) { %>
            <% for (EmergencyContact contact : emergencyContacts) { %>
                <div class="contact-card">
                    <strong><%= contact.getContactName() %></strong>
                    <% if (contact.isPrimary()) { %>
                        <span class="primary-badge">PRIMARY</span>
                    <% } %>
                    <br>
                    <small>Relationship: <%= contact.getRelationship() %></small><br>
                    <small>Phone: <%= contact.getPhone() %></small><br>
                    <% if (contact.getEmail() != null) { %>
                        <small>Email: <%= contact.getEmail() %></small>
                    <% } %>
                </div>
            <% } %>
        <% } else { %>
            <p style="color: #7f8c8d;">No emergency contacts recorded. <a href="addEmergencyContact.jsp?member_id=<%= member.getMemberId() %>">Add contact</a></p>
        <% } %>
    </div>
</div>

<%@ include file="/includes/footer.jsp" %>