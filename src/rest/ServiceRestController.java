package rest;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

import com.google.gson.Gson;

@WebServlet("/api/services/*")
public class ServiceRestController extends HttpServlet {
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
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all active services
                List<Service> services = serviceDAO.getAllActiveServices();
                String json = gson.toJson(services);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(json);
                
            } else if (pathInfo.startsWith("/category/")) {
                // Get services by category
                String categoryIdStr = pathInfo.substring("/category/".length());
                int categoryId = Integer.parseInt(categoryIdStr);
                
                List<Service> services = serviceDAO.getServicesByCategory(categoryId);
                String json = gson.toJson(services);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(json);
                
            } else if (pathInfo.matches("/\\d+")) {
                // Get service by ID
                int serviceId = Integer.parseInt(pathInfo.substring(1));
                Service service = serviceDAO.getServiceById(serviceId);
                
                if (service != null) {
                    String json = gson.toJson(service);
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.print(json);
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\":\"Service not found\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Invalid endpoint\"}");
            }
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid ID format\"}");
        } finally {
            out.flush();
        }
    }
}