package controller.admin;

import dao.BookingDAO;
import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

/**
 * TopClientsController - Generate reports on top clients by spending
 * Required: Listing of top clients by value of services used
 */
@WebServlet("/TopClientsController")
public class TopClientsController extends HttpServlet {
    private BookingDAO bookingDAO;
    private MemberDAO memberDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        memberDAO = new MemberDAO();
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
            // Get top 10 clients by spending
            Map<Integer, BigDecimal> topClients = bookingDAO.getTopClientsBySpending(10);
            
            // Get member details
            List<Map<String, Object>> clientDetails = new ArrayList<>();
            for (Map.Entry<Integer, BigDecimal> entry : topClients.entrySet()) {
                Member member = memberDAO.getMemberById(entry.getKey());
                if (member != null) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("member", member);
                    detail.put("totalSpent", entry.getValue());
                    clientDetails.add(detail);
                }
            }
            
            request.setAttribute("clientDetails", clientDetails);
            request.setAttribute("reportTitle", "Top Clients by Spending");
            
            request.getRequestDispatcher("/views/admin/topClientsReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/topClientsReport.jsp").forward(request, response);
        }
    }
}