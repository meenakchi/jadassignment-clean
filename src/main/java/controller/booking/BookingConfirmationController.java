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
 * BookingConfirmationController - Displays booking confirmation
 */
@WebServlet("/BookingConfirmationController")
public class BookingConfirmationController extends HttpServlet {
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

        String bookingIdParam = request.getParameter("booking_id");
        
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            
            // Get booking details
            Booking booking = bookingDAO.getBookingById(bookingId);
            List<BookingDetail> details = bookingDAO.getBookingDetails(bookingId);
            
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
                return;
            }
            
            // Verify booking belongs to logged-in member
            int memberId = (Integer) session.getAttribute("member_id");
            if (booking.getMemberId() != memberId) {
                response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
                return;
            }

            request.setAttribute("booking", booking);
            request.setAttribute("bookingDetails", details);
            request.getRequestDispatcher("/views/booking/confirmation.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading booking: " + e.getMessage());
            request.getRequestDispatcher("/views/booking/confirmation.jsp").forward(request, response);
        }
    }
}