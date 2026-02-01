package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/MemberDashboardController",
    "/UpdateProfileController",
    "/ViewCartController",
    "/AddToCartController",
    "/RemoveFromCartController",
    "/UpdateCartController",
    "/CheckoutController",
    "/BookingConfirmationController",
    "/BookingHistoryController",
    "/ViewBookingController",
    "/PaymentController",
    "/memberDashboard.jsp",
    "/views/member/*",
    "/views/cart/*",
    "/views/booking/*"
})
public class MemberAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("member_id") != null);
        
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/MemberLoginController");
        }
    }
}