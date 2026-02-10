package controller.api;

import dao.ServiceDAO;
import model.Service;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * REST API for B2B partners to retrieve care services
 * Endpoints:
 * - GET /api/services - Get all services
 * - GET /api/services/{id} - Get service by ID
 * - GET /api/services/category/{categoryId} - Get services by category
 */
@WebServlet(urlPatterns = {"/api/services", "/api/services/*"})
public class ServiceRestAPI extends HttpServlet {
    private ServiceDAO serviceDAO;
    private Gson gson;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set CORS headers for cross-origin requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/services - Get all services
                List<Service> services = serviceDAO.getAllActiveServices();
                String json = gson.toJson(services);
                out.print(json);
                
            } else if (pathInfo.startsWith("/category/")) {
                // GET /api/services/category/{categoryId}
                String categoryIdStr = pathInfo.substring("/category/".length());
                int categoryId = Integer.parseInt(categoryIdStr);
                
                List<Service> services = serviceDAO.getServicesByCategory(categoryId);
                String json = gson.toJson(services);
                out.print(json);
                
            } else {
                // GET /api/services/{id}
                String serviceIdStr = pathInfo.substring(1);
                int serviceId = Integer.parseInt(serviceIdStr);
                
                Service service = serviceDAO.getServiceById(serviceId);
                if (service != null) {
                    String json = gson.toJson(service);
                    out.print(json);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Service not found\"}");
                }
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid ID format\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle CORS preflight
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}