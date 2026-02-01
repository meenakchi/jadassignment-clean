package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/AdminDashboardController",
    "/ManageServicesController",
    "/ManageMembersController",
    "/ManageBookingsController",
    "/adminDashboard.jsp",
    "/manageServices.jsp",
    "/manageMembers.jsp",
    "/manageBookings.jsp",
    "/manageAdmin.jsp",
    "/addServices.jsp",
    "/addAdmin.jsp",
    "/editService.jsp",
    "/editMember.jsp",
    "/editAdmin.jsp",
    "/viewService.jsp",
    "/viewMember.jsp",
    "/viewAdmin.jsp",
    "/views/admin/*"
})
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("admin_id") != null);
        
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/AdminLoginController");
        }
    }
}