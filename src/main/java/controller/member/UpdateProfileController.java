package controller.member;

import dao.MemberDAO;
import model.Member;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

/**
 * UpdateProfileController - Handles member profile updates
 */
@WebServlet("/UpdateProfileController")
public class UpdateProfileController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
                // Update fields
                member.setFullName(request.getParameter("full_name"));
                member.setEmail(request.getParameter("email"));
                member.setPhone(request.getParameter("phone"));
                member.setAddress(request.getParameter("address"));
                
                String dob = request.getParameter("dob");
                if (dob != null && !dob.trim().isEmpty()) {
                    member.setDateOfBirth(Date.valueOf(dob));
                }

                boolean success = memberDAO.updateMember(member);

                if (success) {
                    // Update session
                    session.setAttribute("full_name", member.getFullName());
                    session.setAttribute("email", member.getEmail());
                    
                    request.setAttribute("successMessage", "Profile updated successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to update profile");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/MemberDashboardController");
    }
}