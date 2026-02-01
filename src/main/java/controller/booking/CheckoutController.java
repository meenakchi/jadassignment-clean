package controller.booking;

import dao.BookingDAO;
import dao.CartDAO;
import model.Booking;
import model.BookingDetail;
import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * CheckoutController - Handles checkout process and booking creation
 */
@WebServlet("/CheckoutController")
public class CheckoutController extends HttpServlet {
    private CartDAO cartDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
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

        int memberId = (Integer) session.getAttribute("member_id");

        try {
            List<CartItem> cartItems = cartDAO.getCartItemsByMemberId(memberId);
            
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ViewCartController?error=empty");
                return;
            }

            BigDecimal cartTotal = cartDAO.getCartTotal(memberId);
            BigDecimal gst = cartTotal.multiply(new BigDecimal("0.08"));
            BigDecimal totalWithGST = cartTotal.add(gst);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            request.setAttribute("gst", gst);
            request.setAttribute("totalWithGST", totalWithGST);

            request.getRequestDispatcher("/views/booking/checkout.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading checkout: " + e.getMessage());
            request.getRequestDispatcher("/views/cart/viewCart.jsp").forward(request, response);
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

        int memberId = (Integer) session.getAttribute("member_id");

        try {
            // Get cart items
            List<CartItem> cartItems = cartDAO.getCartItemsByMemberId(memberId);
            
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ViewCartController?error=empty");
                return;
            }

            // Get booking details from form
            String bookingDateStr = request.getParameter("booking_date");
            String bookingTimeStr = request.getParameter("booking_time");
            String specialRequests = request.getParameter("special_requests");
            String paymentMethod = request.getParameter("payment_method");

            // Calculate total
            BigDecimal cartTotal = cartDAO.getCartTotal(memberId);
            BigDecimal gst = cartTotal.multiply(new BigDecimal("0.08"));
            BigDecimal totalWithGST = cartTotal.add(gst);

            // Create booking
            Booking booking = new Booking();
            booking.setMemberId(memberId);
            booking.setBookingDate(Date.valueOf(bookingDateStr));
            booking.setBookingTime(Time.valueOf(bookingTimeStr + ":00"));
            booking.setTotalAmount(totalWithGST);
            booking.setStatus("PENDING");
            booking.setSpecialRequests(specialRequests);

            // Create booking details from cart
            List<BookingDetail> details = new ArrayList<>();
            for (CartItem item : cartItems) {
                BookingDetail detail = new BookingDetail();
                detail.setServiceId(item.getServiceId());
                detail.setQuantity(item.getQuantity());
                detail.setSubtotal(item.getSubtotal());
                details.add(detail);
            }

            // Save booking (transaction)
            int bookingId = bookingDAO.createBooking(booking, details);

            if (bookingId > 0) {
                // Clear cart after successful booking
                cartDAO.clearCart(memberId);

                // Store booking ID in session for confirmation page
                session.setAttribute("last_booking_id", bookingId);
                session.setAttribute("payment_method", paymentMethod);

                // Redirect based on payment method
                if ("online".equals(paymentMethod)) {
                    // Redirect to payment gateway simulation
                    response.sendRedirect(request.getContextPath() + "/PaymentController?booking_id=" + bookingId);
                } else {
                    // Direct to confirmation page for cash/other payment
                    response.sendRedirect(request.getContextPath() + "/BookingConfirmationController?booking_id=" + bookingId);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create booking. Please try again.");
                doGet(request, response);
            }

        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing checkout: " + e.getMessage());
            doGet(request, response);
        }
    }
}
