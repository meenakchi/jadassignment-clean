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
    
    <!-- Orange navbar override styles -->
    <style>
        /* Override navbar button styles with orange */
        .nav-menu .btn-login {
            background-color: transparent !important;
             padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .nav-menu .btn-login:hover {
            background-color: #FFA500 !important;
            color: white !important;
        }

        .nav-menu .btn-register {
            color: white !important;
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .nav-menu .btn-register:hover {
            background-color: #FF8C00 !important;
        }

        /* Update the Book a service button to orange */
        .btn-primary {
            background-color: #FFA500 !important;
            color: white !important;
        }

        .btn-primary:hover {
            background-color: #FF8C00 !important;
        }
    </style>
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
                    <li><a href="${pageContext.request.contextPath}/ServicesController">Services</a></li>
                    <li><a href="<%= request.getContextPath() %>/about.jsp">About</a></li>
                    <li><a href="<%= request.getContextPath() %>/contact.jsp">Contact</a></li>

                    <% if (headerIsLoggedIn) { %>
                        <!-- User logged in -->
                        <a href="<%= request.getContextPath() %>/views/member/dashboard.jsp">Dashboard</a></li>
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
