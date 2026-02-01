package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

/**
 * Handles dynamic image uploads for services
 */
@WebServlet("/ImageUploadController")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50      // 50MB
)
public class ImageUploadController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "images/uploads";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("admin_id") == null) {
            response.sendRedirect(request.getContextPath() + "/AdminLoginController");
            return;
        }
        
        // Get the uploaded file
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // Create unique filename
        String timestamp = String.valueOf(System.currentTimeMillis());
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        String uniqueFileName = "service_" + timestamp + fileExtension;
        
        // Get the absolute path
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Create directory if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        
        // Return the relative URL
        String imageUrl = UPLOAD_DIR + "/" + uniqueFileName;
        
        // Store in session for service creation/update
        session.setAttribute("uploaded_image_url", imageUrl);
        
        // Redirect back to service form
        String serviceId = request.getParameter("service_id");
        if (serviceId != null && !serviceId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + 
                "/ManageServicesController?action=edit&id=" + serviceId + "&image_uploaded=true");
        } else {
            response.sendRedirect(request.getContextPath() + 
                "/ManageServicesController?image_uploaded=true");
        }
    }
}