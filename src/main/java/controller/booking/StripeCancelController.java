package controller.booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles cancelled Stripe payment
 * User clicked "back" or cancelled payment
 */
@WebServlet("/payment/cancel")
public class StripeCancelController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }
        
        String bookingIdParam = request.getParameter("booking_id");
        
        // Show message that payment was cancelled
        session.setAttribute("message", "Payment was cancelled. Your booking is still pending. You can try again anytime.");
        session.setAttribute("messageType", "error");
        
        // Redirect back to cart
        response.sendRedirect(request.getContextPath() + "/ViewCartController");
    }
}