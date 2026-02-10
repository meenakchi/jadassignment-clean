package controller.admin;

import dao.ServiceDAO;
import dao.BookingDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * ServiceDemandController - Generate reports on service demand and availability
 * Required: Listing of services with low availability or high demand
 */
@WebServlet("/ServiceDemandController")
public class ServiceDemandController extends HttpServlet {
    private ServiceDAO serviceDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
        bookingDAO = new BookingDAO();
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
        if (action == null) action = "high_demand";

        try {
            if ("high_demand".equals(action)) {
                // Services with high demand (most bookings)
                List<Service> services = serviceDAO.getAllServices();
                Map<Integer, Integer> bookingCounts = new HashMap<>();
                
                // Count bookings per service
                for (Service service : services) {
                    int count = bookingDAO.getBookingCountByService(service.getServiceId());
                    bookingCounts.put(service.getServiceId(), count);
                }
                
                // Sort by booking count descending
                services.sort((s1, s2) -> 
                    bookingCounts.getOrDefault(s2.getServiceId(), 0).compareTo(
                    bookingCounts.getOrDefault(s1.getServiceId(), 0))
                );
                
                request.setAttribute("services", services);
                request.setAttribute("bookingCounts", bookingCounts);
                request.setAttribute("reportTitle", "High Demand Services");
                request.setAttribute("reportType", "high_demand");
                
            } else if ("low_availability".equals(action)) {
                // Services marked as inactive or with low capacity
                List<Service> inactiveServices = new ArrayList<>();
                List<Service> allServices = serviceDAO.getAllServices();
                
                for (Service service : allServices) {
                    if (!service.isActive()) {
                        inactiveServices.add(service);
                    }
                }
                
                request.setAttribute("services", inactiveServices);
                request.setAttribute("reportTitle", "Low Availability Services");
                request.setAttribute("reportType", "low_availability");
            }

            request.getRequestDispatcher("/views/admin/serviceDemandReport.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/serviceDemandReport.jsp").forward(request, response);
        }
    }
}