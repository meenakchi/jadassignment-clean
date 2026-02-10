package controller.admin;

import dao.MemberDAO;
import dao.MemberMedicalDAO;
import model.Member;
import model.MemberMedicalInfo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * ClientCareNeedsController - Generate reports on clients by specific care needs
 * Required: Listing of clients by specific care needs
 */
@WebServlet("/ClientCareNeedsController")
public class ClientCareNeedsController extends HttpServlet {
    private MemberDAO memberDAO;
    private MemberMedicalDAO medicalDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
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

        String careNeed = request.getParameter("care_need");
        if (careNeed == null) careNeed = "all";

        try {
            List<Member> allMembers = memberDAO.getAllMembers();
            Map<String, List<Member>> membersByCareNeed = new LinkedHashMap<>();
            
            // Categories of care needs
            membersByCareNeed.put("Mobility Assistance", new ArrayList<>());
            membersByCareNeed.put("Medication Management", new ArrayList<>());
            membersByCareNeed.put("Dietary Restrictions", new ArrayList<>());
            membersByCareNeed.put("Chronic Conditions", new ArrayList<>());
            
            for (Member member : allMembers) {
                MemberMedicalInfo medicalInfo = medicalDAO.getMedicalInfo(member.getMemberId());
                
                if (medicalInfo != null) {
                    // Categorize by mobility
                    if (medicalInfo.getMobilityStatus() != null && 
                        !medicalInfo.getMobilityStatus().isEmpty() &&
                        !medicalInfo.getMobilityStatus().equalsIgnoreCase("Independent")) {
                        membersByCareNeed.get("Mobility Assistance").add(member);
                    }
                    
                    // Categorize by medications
                    if (medicalInfo.getMedications() != null && 
                        !medicalInfo.getMedications().isEmpty()) {
                        membersByCareNeed.get("Medication Management").add(member);
                    }
                    
                    // Categorize by dietary restrictions
                    if (medicalInfo.getDietaryRestrictions() != null && 
                        !medicalInfo.getDietaryRestrictions().isEmpty()) {
                        membersByCareNeed.get("Dietary Restrictions").add(member);
                    }
                    
                    // Categorize by chronic conditions
                    if (medicalInfo.getMedicalConditions() != null && 
                        !medicalInfo.getMedicalConditions().isEmpty()) {
                        membersByCareNeed.get("Chronic Conditions").add(member);
                    }
                }
            }
            
            request.setAttribute("membersByCareNeed", membersByCareNeed);
            request.setAttribute("reportTitle", "Clients by Care Needs");
            
            request.getRequestDispatcher("/views/admin/clientCareNeedsReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/clientCareNeedsReport.jsp").forward(request, response);
        }
    }
}