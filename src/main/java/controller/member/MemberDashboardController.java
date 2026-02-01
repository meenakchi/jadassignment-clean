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
                request.setAttribute("member", member);
                request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
            } else {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/views/member/dashboard.jsp").forward(request, response);
        }
    }
}
