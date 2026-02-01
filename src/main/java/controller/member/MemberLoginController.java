package controller.member;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * MemberLoginController - Handles member login
 */
@WebServlet("/MemberLoginController")
public class MemberLoginController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/views/member/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Member member = memberDAO.validateLogin(username, password);

            if (member != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("member_id", member.getMemberId());
                session.setAttribute("username", member.getUsername());
                session.setAttribute("full_name", member.getFullName());
                session.setAttribute("email", member.getEmail());
                session.setAttribute("role", "member");

                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
            } else {
                // Login failed
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/views/member/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/member/login.jsp").forward(request, response);
        }
    }
}
