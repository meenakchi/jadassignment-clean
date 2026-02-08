<%
    // Check if admin is logged in
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>