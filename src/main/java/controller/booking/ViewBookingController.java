package controller.booking;

import dao.BookingDAO;
import model.Booking;
import model.BookingDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * ViewBookingController - Displays detailed booking information
 * Used by both members (to view their own bookings) and admins (to view any booking)
 */
@WebServlet("/ViewBookingController")
public class ViewBookingController extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in (either member or admin)
        if (session == null || 
            (session.getAttribute("member_id") == null && session.getAttribute("admin_id") == null)) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        String bookingIdParam = request.getParameter("id");
        
        if (bookingIdParam == null) {
            // Redirect based on user type
            if (session.getAttribute("admin_id") != null) {
                response.sendRedirect(request.getContextPath() + "/ManageBookingsController");
            } else {
                response.sendRedirect(request.getContextPath() + "/BookingHistoryController");
            }
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // Get booking details
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                request.setAttribute("errorMessage", "Booking not found");
                request.getRequestDispatcher("/views/booking/viewBooking.jsp").forward(request, response);
                return;
            }
            
            // Security check: Members can only view their own bookings
            Integer memberId = (Integer) session.getAttribute("member_id");
            Integer adminId = (Integer) session.getAttribute("admin_id");
            
            if (memberId != null && booking.getMemberId() != memberId) {
                // Member trying to access someone else's booking
                request.setAttribute("errorMessage", "You don't have permission to view this booking");
                request.getRequestDispatcher("/views/booking/viewBooking.jsp").forward(request, response);
                return;
            }
            
            // Get booking details (services)
            List<BookingDetail> bookingDetails = bookingDAO.getBookingDetails(bookingId);
            
            // Set attributes
            request.setAttribute("booking", booking);
            request.setAttribute("bookingDetails", bookingDetails);
            request.setAttribute("isAdmin", adminId != null);
            
            request.getRequestDispatcher("/views/booking/viewBooking.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading booking: " + e.getMessage());
            request.getRequestDispatcher("/views/booking/viewBooking.jsp").forward(request, response);
        }
    }
}