package controller.admin;

import dao.ServiceDAO;
import dao.FeedbackDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/ServiceSearchController")
public class ServiceSearchController extends HttpServlet {
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
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("best_rated".equals(action)) {
                // Get best rated services
                List<Service> services = serviceDAO.getAllActiveServices();
                Map<Integer, Double> ratings = new HashMap<>();
                
                for (Service service : services) {
                    double avgRating = feedbackDAO.getAverageRating(service.getServiceId());
                    ratings.put(service.getServiceId(), avgRating);
                }
                
                // Sort by rating descending
                List<Service> sortedServices = services.stream()
                    .sorted((s1, s2) -> Double.compare(
                        ratings.getOrDefault(s2.getServiceId(), 0.0),
                        ratings.getOrDefault(s1.getServiceId(), 0.0)
                    ))
                    .limit(10)
                    .collect(Collectors.toList());
                
                request.setAttribute("services", sortedServices);
                request.setAttribute("ratings", ratings);
                request.setAttribute("reportTitle", "Best Rated Services");
                
            } else if ("lowest_rated".equals(action)) {
                // Get lowest rated services
                List<Service> services = serviceDAO.getAllActiveServices();
                Map<Integer, Double> ratings = new HashMap<>();
                
                for (Service service : services) {
                    double avgRating = feedbackDAO.getAverageRating(service.getServiceId());
                    ratings.put(service.getServiceId(), avgRating);
                }
                
                // Sort by rating ascending
                List<Service> sortedServices = services.stream()
                    .filter(s -> ratings.getOrDefault(s.getServiceId(), 0.0) > 0)
                    .sorted((s1, s2) -> Double.compare(
                        ratings.getOrDefault(s1.getServiceId(), 0.0),
                        ratings.getOrDefault(s2.getServiceId(), 0.0)
                    ))
                    .limit(10)
                    .collect(Collectors.toList());
                
                request.setAttribute("services", sortedServices);
                request.setAttribute("ratings", ratings);
                request.setAttribute("reportTitle", "Lowest Rated Services");
                
            } else {
                // List all services
                List<Service> services = serviceDAO.getAllServices();
                request.setAttribute("services", services);
                request.setAttribute("reportTitle", "All Services");
            }

            request.getRequestDispatcher("/views/admin/serviceReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/serviceReport.jsp").forward(request, response);
        }
    }
}