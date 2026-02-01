package controller.admin;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ClientReportsController - Generate reports on clients
 * Required by assignment: "Listing of clients by residential area code"
 */
@WebServlet("/ClientReportsController")
public class ClientReportsController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
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

        String action = request.getParameter("action");
        if (action == null) action = "by_area";

        try {
            if ("by_area".equals(action)) {
                // Group clients by residential area/postal code
                List<Member> allMembers = memberDAO.getAllMembers();
                
                Map<String, List<Member>> membersByArea = allMembers.stream()
                    .filter(m -> m.getAddress() != null && !m.getAddress().isEmpty())
                    .collect(Collectors.groupingBy(m -> {
                        // Extract area code from address (first 2 digits of postal code)
                        String address = m.getAddress();
                        // Try to find postal code pattern (6 digits in Singapore)
                        if (address.matches(".*\\d{6}.*")) {
                            String postal = address.replaceAll(".*?(\\d{6}).*", "$1");
                            return postal.substring(0, 2); // First 2 digits = area
                        }
                        return "Unknown";
                    }));
                
                request.setAttribute("membersByArea", membersByArea);
                request.setAttribute("reportTitle", "Clients by Residential Area");
                
            } else if ("all".equals(action)) {
                List<Member> members = memberDAO.getAllMembers();
                request.setAttribute("members", members);
                request.setAttribute("reportTitle", "All Clients");
            }

            request.getRequestDispatcher("/views/admin/clientReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/clientReport.jsp").forward(request, response);
        }
    }
}