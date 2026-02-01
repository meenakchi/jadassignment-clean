<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="model.Member" %>
<%@ include file="/includes/header.jsp" %>

<%
    Map<String, List<Member>> membersByArea = 
        (Map<String, List<Member>>) request.getAttribute("membersByArea");
    List<Member> members = (List<Member>) request.getAttribute("members");
    String reportTitle = (String) request.getAttribute("reportTitle");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .area-section {
        background: white;
        padding: 25px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .area-header {
        background: #3498db;
        color: white;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 15px;
        font-size: 1.2rem;
        font-weight: 600;
    }
    .member-item {
        padding: 15px;
        border-bottom: 1px solid #ecf0f1;
    }
    .member-item:last-child {
        border-bottom: none;
    }
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <h2 style="margin: 20px 0;"><%= reportTitle %></h2>

    <% if (membersByArea != null) { %>
        <% for (Map.Entry<String, List<Member>> entry : membersByArea.entrySet()) { %>
            <div class="area-section">
                <div class="area-header">
                    Area Code: <%= entry.getKey() %> 
                    (<%= entry.getValue().size() %> clients)
                </div>
                
                <% for (Member member : entry.getValue()) { %>
                    <div class="member-item">
                        <strong><%= member.getFullName() %></strong><br>
                        Email: <%= member.getEmail() %><br>
                        <% if (member.getPhone() != null) { %>
                            Phone: <%= member.getPhone() %><br>
                        <% } %>
                        <% if (member.getAddress() != null) { %>
                            Address: <%= member.getAddress() %>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    <% } else if (members != null) { %>
        <div class="area-section">
            <% for (Member member : members) { %>
                <div class="member-item">
                    <strong><%= member.getFullName() %></strong><br>
                    Email: <%= member.getEmail() %><br>
                    <% if (member.getAddress() != null) { %>
                        Address: <%= member.getAddress() %>
                    <% } %>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>