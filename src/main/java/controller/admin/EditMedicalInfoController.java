package controller.admin;

import dao.MemberMedicalDAO;
import model.MemberMedicalInfo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/EditMedicalInfoController")
public class EditMedicalInfoController extends HttpServlet {
    private MemberMedicalDAO medicalDAO;

    @Override
    public void init() {
        medicalDAO = new MemberMedicalDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        int memberId = Integer.parseInt(request.getParameter("member_id"));

        try {
            MemberMedicalInfo medicalInfo = medicalDAO.getMedicalInfo(memberId);
            
            request.setAttribute("member_id", memberId);
            request.setAttribute("medicalInfo", medicalInfo);
            request.getRequestDispatcher("/views/admin/editMedicalInfo.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MemberDetailsController?id=" + memberId);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        int memberId = Integer.parseInt(request.getParameter("member_id"));

        try {
            MemberMedicalInfo medicalInfo = new MemberMedicalInfo();
            medicalInfo.setMemberId(memberId);
            medicalInfo.setBloodType(request.getParameter("blood_type"));
            medicalInfo.setAllergies(request.getParameter("allergies"));
            medicalInfo.setMedications(request.getParameter("medications"));
            medicalInfo.setMedicalConditions(request.getParameter("medical_conditions"));
            medicalInfo.setMobilityStatus(request.getParameter("mobility_status"));
            medicalInfo.setDietaryRestrictions(request.getParameter("dietary_restrictions"));

            boolean success = medicalDAO.saveMedicalInfo(medicalInfo);
            
            if (success) {
                session.setAttribute("message", "Medical information updated successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to update medical information");
                session.setAttribute("messageType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/MemberDetailsController?id=" + memberId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/MemberDetailsController?id=" + memberId);
        }
    }
}