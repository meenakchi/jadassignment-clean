package controller.member;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * MemberDashboardController - Displays member dashboard
 * FIXED: Maintains session properly when navigating between pages
 */
@WebServlet("/MemberDashboardController")
public class MemberDashboardController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
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
            Member member = memberDAO.getMemberById(memberId);
            
            if (member != null) {
                // Refresh session attributes with current data
                session.setAttribute("full_name", member.getFullName());
                session.setAttribute("email", member.getEmail());
                
                request.setAttribute("member", member);
                request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
            } else {
                // Only invalidate if member truly doesn't exist in database
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Don't invalidate session on database errors - just show error
            request.setAttribute("errorMessage", "Error loading profile: " + e.getMessage());
            
            // Create a minimal member object from session data to prevent null pointer
            Member member = new Member();
            member.setMemberId(memberId);
            member.setFullName((String) session.getAttribute("full_name"));
            member.setEmail((String) session.getAttribute("email"));
            member.setUsername((String) session.getAttribute("username"));
            
            request.setAttribute("member", member);
            request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
        }
    }
}