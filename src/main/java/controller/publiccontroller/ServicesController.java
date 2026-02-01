package controller.publiccontroller;

import dao.ServiceDAO;
import model.Service;
import model.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ServicesController")
public class ServicesController extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryParam = request.getParameter("category");
        
        // FIX: Default to "all" if no category parameter provided
        if (categoryParam == null || categoryParam.trim().isEmpty()) {
            categoryParam = "all";
        }

        try {
            List<Service> services;
            
            if (categoryParam.equals("all")) {
                // Get all active services
                services = serviceDAO.getAllActiveServices();
            } else {
                // Get services by specific category
                int categoryId = Integer.parseInt(categoryParam);
                services = serviceDAO.getServicesByCategory(categoryId);
            }

            List<ServiceCategory> categories = serviceDAO.getAllCategories();

            request.setAttribute("services", services);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", categoryParam);

            request.getRequestDispatcher("/services.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading services: " + e.getMessage());
            request.getRequestDispatcher("/services.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // If invalid category ID, default to all services
            try {
                List<Service> services = serviceDAO.getAllActiveServices();
                List<ServiceCategory> categories = serviceDAO.getAllCategories();
                
                request.setAttribute("services", services);
                request.setAttribute("categories", categories);
                request.setAttribute("selectedCategory", "all");
                
                request.getRequestDispatcher("/services.jsp").forward(request, response);
            } catch (SQLException ex) {
                ex.printStackTrace();
                request.setAttribute("errorMessage", "Error loading services: " + ex.getMessage());
                request.getRequestDispatcher("/services.jsp").forward(request, response);
            }
        }
    }
}