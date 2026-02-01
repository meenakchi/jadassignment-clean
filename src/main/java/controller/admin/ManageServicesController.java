package controller.admin;

import dao.ServiceDAO;
import model.Service;
import model.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageServicesController")
public class ManageServicesController extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
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

        try {
            if ("delete".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("id"));
                boolean success = serviceDAO.deleteService(serviceId);
                
                if (success) {
                    session.setAttribute("message", "Service deleted successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to delete service");
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/ManageServicesController");
                return;
                
            } else if ("toggle".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("id"));
                boolean success = serviceDAO.toggleServiceStatus(serviceId);
                
                if (success) {
                    session.setAttribute("message", "Service status updated!");
                    session.setAttribute("messageType", "success");
                }
                
                response.sendRedirect(request.getContextPath() + "/ManageServicesController");
                return;
            }

            // Default: List all services
            List<Service> services = serviceDAO.getAllServices();
            List<ServiceCategory> categories = serviceDAO.getAllCategories();

            request.setAttribute("services", services);
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/manageServices.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/manageServices.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                Service service = new Service();
                service.setServiceName(request.getParameter("service_name"));
                service.setDescription(request.getParameter("description"));
                service.setPrice(new BigDecimal(request.getParameter("price")));
                service.setDuration(Integer.parseInt(request.getParameter("duration")));
                service.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
                service.setImageUrl(request.getParameter("image_url"));
                service.setActive(request.getParameter("is_active") != null);

                boolean success = serviceDAO.addService(service);
                
                if (success) {
                    session.setAttribute("message", "Service added successfully!");
                    session.setAttribute("messageType", "success");
                }
                
            } else if ("update".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("service_id"));
                Service service = serviceDAO.getServiceById(serviceId);
                
                if (service != null) {
                    service.setServiceName(request.getParameter("service_name"));
                    service.setDescription(request.getParameter("description"));
                    service.setPrice(new BigDecimal(request.getParameter("price")));
                    service.setDuration(Integer.parseInt(request.getParameter("duration")));
                    service.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
                    service.setImageUrl(request.getParameter("image_url"));
                    service.setActive(request.getParameter("is_active") != null);

                    boolean success = serviceDAO.updateService(service);
                    
                    if (success) {
                        session.setAttribute("message", "Service updated successfully!");
                        session.setAttribute("messageType", "success");
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/ManageServicesController");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/ManageServicesController");
        }
    }
}