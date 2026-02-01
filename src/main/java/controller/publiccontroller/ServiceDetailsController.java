package controller.publiccontroller;

import dao.ServiceDAO;
import dao.FeedbackDAO;
import model.Service;
import model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ServiceDetailsController")
public class ServiceDetailsController extends HttpServlet {
    private ServiceDAO serviceDAO;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String serviceIdParam = request.getParameter("id");

        if (serviceIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/ServicesController");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            Service service = serviceDAO.getServiceById(serviceId);

            if (service == null) {
                response.sendRedirect(request.getContextPath() + "/ServicesController");
                return;
            }

            // Get feedback for this service
            List<Feedback> feedbackList = feedbackDAO.getFeedbackByServiceId(serviceId);
            double avgRating = feedbackDAO.getAverageRating(serviceId);

            request.setAttribute("service", service);
            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("avgRating", avgRating);

            request.getRequestDispatcher("/serviceDetails.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ServicesController");
        }
    }
}