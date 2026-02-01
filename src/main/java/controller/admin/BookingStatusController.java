package controller.admin;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Handles real-time booking status updates
 * Statuses: PENDING -> CONFIRMED -> IN_PROGRESS -> COMPLETED
 */
@WebServlet("/BookingStatusController")
public class BookingStatusController extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Allow both admin and staff to update status
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String action = request.getParameter("action");
        String bookingIdParam = request.getParameter("booking_id");

        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/ManageBookingsController");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking == null) {
                session.setAttribute("message", "Booking not found");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/ManageBookingsController");
                return;
            }

            String newStatus = null;
            String message = null;

            switch (action) {
                case "checkin":
                    newStatus = "IN_PROGRESS";
                    message = "Caregiver checked in - Service started";
                    break;
                case "checkout":
                    newStatus = "COMPLETED";
                    message = "Caregiver checked out - Service completed";
                    break;
                case "confirm":
                    newStatus = "CONFIRMED";
                    message = "Booking confirmed";
                    break;
                case "cancel":
                    newStatus = "CANCELLED";
                    message = "Booking cancelled";
                    break;
                default:
                    newStatus = request.getParameter("status");
                    message = "Status updated";
            }

            if (newStatus != null) {
                boolean success = bookingDAO.updateBookingStatus(bookingId, newStatus);
                
                if (success) {
                    // Log the status change (you could add a status_log table)
                    logStatusChange(bookingId, booking.getStatus(), newStatus, session);
                    
                    session.setAttribute("message", message);
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update status");
                    session.setAttribute("messageType", "error");
                }
            }

            response.sendRedirect(request.getContextPath() + "/ManageBookingsController");

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageBookingsController");
        }
    }

    /**
     * Log status changes for audit trail
     */
    private void logStatusChange(int bookingId, String oldStatus, String newStatus, HttpSession session) {
        // This would insert into a booking_status_log table
        // For now, just log to console
        String adminName = (String) session.getAttribute("admin_name");
        System.out.println(String.format(
            "[%s] Booking #%d: %s -> %s (by %s)",
            new Timestamp(System.currentTimeMillis()),
            bookingId,
            oldStatus,
            newStatus,
            adminName
        ));
    }
}