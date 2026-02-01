package controller.booking;

import dao.BookingDAO;
import model.Booking;
import service.PaymentGatewayService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * PaymentController - Handles payment processing
 * Meets Assignment Requirement: Payment processing for services rendered
 */
@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {
    private BookingDAO bookingDAO;
    private PaymentGatewayService paymentService;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        paymentService = new PaymentGatewayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        String bookingIdParam = request.getParameter("booking_id");
        
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking != null) {
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/views/booking/payment.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            }

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        String bookingIdParam = request.getParameter("booking_id");
        
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                request.setAttribute("errorMessage", "Booking not found");
                doGet(request, response);
                return;
            }
            
            // Call your Stripe service
            String stripeCheckoutUrl = paymentService.createStripeSession((model.Booking) booking);
            
            // Redirect to Stripe checkout
            response.sendRedirect(stripeCheckoutUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Payment error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
