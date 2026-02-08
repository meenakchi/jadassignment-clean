package controller.admin;

import dao.ServiceDAO;
import model.Service;
import model.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ManageServicesController")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
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

        try {
            // Fetch data to display on the management page
            List<Service> services = serviceDAO.getAllServices();
            List<ServiceCategory> categories = serviceDAO.getAllCategories(); // Assuming this exists
            
            request.setAttribute("services", services);
            request.setAttribute("categories", categories);
            
            // Forward to your JSP page
         // Change from "/admin/..." to "/views/admin/..."
            request.getRequestDispatcher("/views/admin/manage-services.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
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
        // Handle image upload
        String imageUrl = null;
        Part filePart = request.getPart("service_image");
        
        if (filePart != null && filePart.getSize() > 0) {
            // File was uploaded
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String timestamp = String.valueOf(System.currentTimeMillis());
            String fileExtension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = "service_" + timestamp + fileExtension;
            
            String uploadPath = getServletContext().getRealPath("/images/services");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            imageUrl = "images/services/" + uniqueFileName;
        } else {
            // No file uploaded, use URL if provided
            imageUrl = request.getParameter("image_url");
        }
        
        if ("add".equals(action)) {
            Service service = new Service();
            service.setServiceName(request.getParameter("service_name"));
            service.setDescription(request.getParameter("description"));
            service.setPrice(new BigDecimal(request.getParameter("price")));
            service.setDuration(Integer.parseInt(request.getParameter("duration")));
            service.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
            service.setImageUrl(imageUrl);
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
                
                // Only update image if new one was uploaded
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    service.setImageUrl(imageUrl);
                }
                
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