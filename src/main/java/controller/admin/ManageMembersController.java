package controller.admin;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageMembersController")
public class ManageMembersController extends HttpServlet {
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

        try {
            if ("delete".equals(action)) {
                int memberId = Integer.parseInt(request.getParameter("id"));
                boolean success = memberDAO.deleteMember(memberId);
                
                if (success) {
                    session.setAttribute("message", "Member deleted successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to delete member");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/ManageMembersController");
                return;
            }

            // Default: List all members
            List<Member> members = memberDAO.getAllMembers();
            request.setAttribute("members", members);

            request.getRequestDispatcher("/manageMembers.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/manageMembers.jsp").forward(request, response);
        }
    }
}