package controller.admin;

import dao.BookingDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/SalesReportController")
public class SalesReportController extends HttpServlet {
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

        String reportType = request.getParameter("type");
        if (reportType == null) reportType = "today";

        try {
            LocalDate endDate = LocalDate.now();
            LocalDate startDate;

            switch (reportType) {
                case "week":
                    startDate = endDate.minusWeeks(1);
                    break;
                case "month":
                    startDate = endDate.minusMonths(1);
                    break;
                case "year":
                    startDate = endDate.minusYears(1);
                    break;
                case "today":
                default:
                    startDate = endDate;
                    break;
            }

            Date sqlStartDate = Date.valueOf(startDate);
            Date sqlEndDate = Date.valueOf(endDate);

            List<Booking> bookings = bookingDAO.getBookingsByDateRange(sqlStartDate, sqlEndDate);
            BigDecimal revenue = bookingDAO.getRevenue(sqlStartDate, sqlEndDate);

            request.setAttribute("bookings", bookings);
            request.setAttribute("revenue", revenue);
            request.setAttribute("reportType", reportType);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("/views/admin/salesReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/salesReport.jsp").forward(request, response);
        }
    }
}