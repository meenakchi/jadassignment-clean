package controller.admin;

import dao.MemberDAO;
import dao.ServiceDAO;
import dao.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * AdminDashboardController - Displays admin dashboard with statistics
 */
@WebServlet("/AdminDashboardController")
public class AdminDashboardController extends HttpServlet {
    private MemberDAO memberDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        try {
            // Get statistics
            int totalMembers = memberDAO.getTotalMemberCount();
            int totalServices = serviceDAO.getTotalServiceCount();
            int activeServices = serviceDAO.getActiveServiceCount();

            request.setAttribute("totalMembers", totalMembers);
            request.setAttribute("totalServices", totalServices);
            request.setAttribute("activeServices", activeServices);

            request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
        }
    }
}