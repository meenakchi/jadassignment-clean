<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Member, java.math.BigDecimal" %>
<%@ include file="/includes/header.jsp" %>

<%
    List<Map<String, Object>> clientDetails = 
        (List<Map<String, Object>>) request.getAttribute("clientDetails");
    String reportTitle = (String) request.getAttribute("reportTitle");
%>

<style>
    .report-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 30px;
    }
    .report-header {
        background: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    table {
        width: 100%;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    thead {
        background: #34495e;
        color: white;
    }
    th, td {
        padding: 15px;
        text-align: left;
    }
    tr {
        border-bottom: 1px solid #ecf0f1;
    }
    .rank-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        font-weight: bold;
        color: white;
    }
    .rank-1 {
        background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
    }
    .rank-2 {
        background: linear-gradient(135deg, #C0C0C0 0%, #808080 100%);
    }
    .rank-3 {
        background: linear-gradient(135deg, #CD7F32 0%, #8B4513 100%);
    }
    .rank-other {
        background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
    }
    .amount-cell {
        font-size: 1.2rem;
        font-weight: bold;
        color: #27ae60;
    }
</style>

<div class="report-container">
    <a href="${pageContext.request.contextPath}/AdminDashboardController" class="back-link">← Back to Dashboard</a>
    
    <div class="report-header">
        <h2><%= reportTitle %></h2>
        <p style="color: #7f8c8d; margin-top: 10px;">
            Ranked by total value of services used
        </p>
    </div>

    <% if (clientDetails == null || clientDetails.isEmpty()) { %>
        <div style="text-align: center; padding: 60px; background: white; border-radius: 10px;">
            <h3>No client data available</h3>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Client Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Total Spent</th>
                </tr>
            </thead>
            <tbody>
                <% 
                int rank = 1;
                for (Map<String, Object> detail : clientDetails) {
                    Member member = (Member) detail.get("member");
                    BigDecimal totalSpent = (BigDecimal) detail.get("totalSpent");
                    String rankClass = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "rank-other";
                %>
                    <tr>
                        <td>
                            <span class="rank-badge <%= rankClass %>">
                                <%= rank %>
                            </span>
                        </td>
                        <td><%= member.getFullName() %></td>
                        <td><%= member.getEmail() %></td>
                        <td><%= member.getPhone() != null ? member.getPhone() : "N/A" %></td>
                        <td class="amount-cell">
                            $<%= String.format("%.2f", totalSpent) %>
                        </td>
                    </tr>
                <% 
                    rank++;
                } 
                %>
            </tbody>
        </table>
    <% } %>
</div>

<%@ include file="/includes/footer.jsp" %>
l>