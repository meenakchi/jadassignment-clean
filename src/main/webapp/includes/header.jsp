<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is logged in
    Integer headerMemberId = (Integer) session.getAttribute("member_id");
    String headerUsername = (String) session.getAttribute("username");
    boolean headerIsLoggedIn = (headerMemberId != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Silver Care - Elderly Care Services</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="container">
                <div class="nav-brand">
                    <h1>Silver Care</h1>
                </div>
                <ul class="nav-menu">
                    <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
<li><a href="${pageContext.request.contextPath}/ServicesController">Services</a></li><li><a href="<%= request.getContextPath() %>/about.jsp">About</a></li>
                    <li><a href="<%= request.getContextPath() %>/contact.jsp">Contact</a></li>

                    <% if (headerIsLoggedIn) { %>
                        <!-- User logged in -->
                        <li><a href="<%= request.getContextPath() %>/memberDashboard.jsp">My Account</a></li>
                        <li><a href="<%= request.getContextPath() %>/logout.jsp" class="btn-logout">Logout</a></li>
                        <li class="nav-user"><%= headerUsername %></li>
                    <% } else { %>
                        <!-- User NOT logged in -->
                        <li><a href="<%= request.getContextPath() %>/views/member/login.jsp" class="btn-login">Member Login</a></li>
                        <li><a href="<%= request.getContextPath() %>/adminLogin.jsp" class="btn-login">Admin Login</a></li>
                        <li><a href="<%= request.getContextPath() %>/registerMember.jsp" class="btn-register">Register</a></li>
                    <% } %>

                </ul>
            </div>
        </nav>
    </header>