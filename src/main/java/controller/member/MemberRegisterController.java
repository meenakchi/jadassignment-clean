package controller.member;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * MemberRegisterController - Handles member registration
 */
@WebServlet("/MemberRegisterController")
public class MemberRegisterController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/registerMember.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        try {
            // Check if username exists
            if (memberDAO.usernameExists(username)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/registerMembers.jsp").forward(request, response);
                return;
            }

            // Create new member
            Member member = new Member(username, password, email, fullName);
            boolean success = memberDAO.registerMember(member);

            if (success) {
                request.setAttribute("successMessage", "Registration successful! Please login.");
                request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/registerMember.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/registerMember.jsp").forward(request, response);
        }
    }
}
