package controller.booking;

import dao.BookingDAO;
import com.stripe.Stripe;
import com.stripe.model.checkout.Session;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles successful Stripe payment callback
 * Verifies payment and updates booking status to CONFIRMED
 */
@WebServlet("/PaymentSuccessController")  // Change this line
public class StripeSuccessController extends HttpServlet {
    private BookingDAO bookingDAO;
    
    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }
        
        String stripeSessionId = request.getParameter("session_id");
        String bookingIdParam = request.getParameter("booking_id");
        
        if (stripeSessionId == null || bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            return;
        }
        
        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // Set Stripe API key
            Stripe.apiKey = System.getenv("STRIPE_SECRET_KEY");
            if (Stripe.apiKey == null || Stripe.apiKey.isEmpty()) {
            	

            }
            
            // Verify payment with Stripe
            Session stripeSession = Session.retrieve(stripeSessionId);
            
            // Check if payment was successful
            if ("paid".equals(stripeSession.getPaymentStatus())) {
                // Update booking status to CONFIRMED
                boolean updated = bookingDAO.updateBookingStatus(bookingId, "CONFIRMED");
                
                if (updated) {
                    session.setAttribute("payment_success", true);
                    session.setAttribute("message", "Payment successful! Booking confirmed.");
                    session.setAttribute("messageType", "success");
                    
                    // Redirect to booking confirmation page
                    response.sendRedirect(request.getContextPath() + 
                        "/BookingConfirmationController?booking_id=" + bookingId);
                } else {
                    session.setAttribute("message", "Payment received but failed to update booking");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
                }
            } else {
                // Payment not completed
                session.setAttribute("message", "Payment was not completed. Status: " + stripeSession.getPaymentStatus());
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/ViewCartController");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Payment verification error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
        }
    }
}