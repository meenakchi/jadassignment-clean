<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Member" %>
<%@ include file="/includes/header.jsp" %>

<%
    Map<String, List<Member>> membersByCareNeed = 
        (Map<String, List<Member>>) request.getAttribute("membersByCareNeed");
    String reportTitle = (String) request.getAttribute("reportTitle");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .care-need-section {
        background: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .care-need-header {
        background: #3498db;
        color: white;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 15px;
        font-size: 1.2rem;
        font-weight: 600;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .count-badge {
        background: white;
        color: #3498db;
        padding: 5px 15px;
        border-radius: 20px;
        font-size: 0.9rem;
        font-weight: bold;
    }
    .client-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
    .client-card {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 5px;
        border-left: 4px solid #3498db;
    }
    .client-name {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    .client-info {
        font-size: 0.9rem;
        color: #7f8c8d;
    }
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <h2 style="margin: 20px 0;"><%= reportTitle %></h2>
    <p style="color: #7f8c8d; margin-bottom: 30px;">
        Clients categorized by their specific care requirements
    </p>

    <% if (membersByCareNeed != null) {
        for (Map.Entry<String, List<Member>> entry : membersByCareNeed.entrySet()) {
            String careNeed = entry.getKey();
            List<Member> membersList = entry.getValue();
    %>
        <div class="care-need-section">
            <div class="care-need-header">
                <span><%= careNeed %></span>
                <span class="count-badge"><%= membersList.size() %> clients</span>
            </div>
            
            <% if (membersList.isEmpty()) { %>
                <p style="color: #7f8c8d; text-align: center; padding: 20px;">
                    No clients in this category
                </p>
            <% } else { %>
                <div class="client-grid">
                    <% for (Member member : membersList) { %>
                        <div class="client-card">
                            <div class="client-name"><%= member.getFullName() %></div>
                            <div class="client-info">
                                <%= member.getEmail() %><br>
                                <% if (member.getPhone() != null) { %>
                                    Phone: <%= member.getPhone() %><br>
                                <% } %>
                                <% if (member.getAddress() != null) { %>
                                    <%= member.getAddress() %>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    <% 
        }
    } 
    %>
</div>

<%@ include file="/includes/footer.jsp" %>
