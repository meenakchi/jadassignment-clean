package controller.publiccontroller;
import dao.FeedbackDAO;
import model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * ViewFeedbackController - View feedback
 * Members can view their own feedback
 * Admins can view all feedback
 */
@WebServlet("/ViewFeedbackController")
public class ViewFeedbackController extends HttpServlet {
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        Integer memberId = (Integer) session.getAttribute("member_id");
        Integer adminId = (Integer) session.getAttribute("admin_id");
        
        if (memberId == null && adminId == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        try {
            List<Feedback> feedbackList;
            String pageTitle;
            boolean isAdmin = (adminId != null);
            
            if (isAdmin) {
                // Admin views all feedback
                feedbackList = feedbackDAO.getAllFeedback();
                pageTitle = "All Customer Feedback";
            } else {
                // Member views their own feedback
                feedbackList = feedbackDAO.getFeedbackByMemberId(memberId);
                pageTitle = "My Feedback";
            }

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("pageTitle", pageTitle);
            request.setAttribute("isAdmin", isAdmin);
            request.getRequestDispatcher("/viewFeedback.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading feedback: " + e.getMessage());
            request.getRequestDispatcher("/viewFeedback.jsp").forward(request, response);
        }
    }
}