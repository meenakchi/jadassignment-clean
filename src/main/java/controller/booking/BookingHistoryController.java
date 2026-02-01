package controller.booking;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * BookingHistoryController - Displays member's booking history
 */
@WebServlet("/BookingHistoryController")
public class BookingHistoryController extends HttpServlet {
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

        int memberId = (Integer) session.getAttribute("member_id");

        try {
            List<Booking> bookings = bookingDAO.getBookingsByMemberId(memberId);

            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/views/booking/history.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading booking history: " + e.getMessage());
            request.getRequestDispatcher("/views/booking/history.jsp").forward(request, response);
        }
    }
}