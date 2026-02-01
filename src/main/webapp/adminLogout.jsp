<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate the admin session
    if(session != null) {
        session.invalidate();
    }
    
    // Redirect to admin login page
    response.sendRedirect("adminLogin.jsp");
%>