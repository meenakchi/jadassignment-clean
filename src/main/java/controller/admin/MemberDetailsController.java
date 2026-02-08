
package controller.admin;

import dao.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/MemberDetailsController")
public class MemberDetailsController extends HttpServlet {
    private MemberDAO memberDAO;
    private MemberMedicalDAO medicalDAO;
    private EmergencyContactDAO contactDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
        medicalDAO = new MemberMedicalDAO();
        contactDAO = new EmergencyContactDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String memberIdParam = request.getParameter("id");
        
        if (memberIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/ManageMembersController");
            return;
        }

        try {
            int memberId = Integer.parseInt(memberIdParam);
            
            Member member = memberDAO.getMemberById(memberId);
            MemberMedicalInfo medicalInfo = medicalDAO.getMedicalInfo(memberId);
            List emergencyContacts = contactDAO.getContactsByMember(memberId);
            
            request.setAttribute("member", member);
            request.setAttribute("medicalInfo", medicalInfo);
            request.setAttribute("emergencyContacts", emergencyContacts);
            
            request.getRequestDispatcher("/views/admin/viewMemberDetails.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading member details: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/viewMemberDetails.jsp").forward(request, response);
        }
    }
}