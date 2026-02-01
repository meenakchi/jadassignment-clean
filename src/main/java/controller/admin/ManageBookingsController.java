package controller.admin;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * ManageBookingsController - Admin controller for managing bookings
 */
@WebServlet("/ManageBookingsController")
public class ManageBookingsController extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                
                boolean success = bookingDAO.updateBookingStatus(bookingId, status);
                
                if (success) {
                    session.setAttribute("message", "Booking status updated successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update booking status");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/ManageBookingsController");
                return;
            }

            // Default: List all bookings
            List<Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);

            request.getRequestDispatcher("/views/admin/manageBookings.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/manageBookings.jsp").forward(request, response);
        }
    }
}