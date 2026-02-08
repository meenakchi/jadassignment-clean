<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="utils.DBConnection" %>

<%
    // Check admin session
    Integer adminId = (Integer) session.getAttribute("admin_id");
    if(adminId == null) {
        response.sendRedirect(request.getContextPath() + "/AdminLoginController");
        return;
    }
    
    int serviceId = Integer.parseInt(request.getParameter("id"));
    Map<String, Object> service = null;
    List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBConnection.getConnection();
        
        String serviceSql = "SELECT * FROM service WHERE service_id=?";
        pstmt = conn.prepareStatement(serviceSql);
        pstmt.setInt(1, serviceId);
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            service = new HashMap<String, Object>();
            service.put("service_id", rs.getInt("service_id"));
            service.put("service_name", rs.getString("service_name"));
            service.put("description", rs.getString("description"));
            service.put("price", rs.getBigDecimal("price"));
            service.put("duration", rs.getInt("duration"));
            service.put("category_id", rs.getInt("category_id"));
            service.put("image_url", rs.getString("image_url"));
            service.put("is_active", rs.getBoolean("is_active"));
        }
        rs.close();
        pstmt.close();
        
        String categorySql = "SELECT * FROM service_category ORDER BY category_name";
        pstmt = conn.prepareStatement(categorySql);
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> category = new HashMap<String, Object>();
            category.put("category_id", rs.getInt("category_id"));
            category.put("category_name", rs.getString("category_name"));
            categories.add(category);
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
    
    if(service == null) {
        response.sendRedirect(request.getContextPath() + "/ManageServicesController");
        return;
    }
%>

<%@ include file="/includes/header.jsp" %>

<style>
    .admin-container {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
    }
    .form-card {
        background-color: #ffffff;
        padding: 35px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .form-header {
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #3498db;
    }
    .form-header h2 {
        color: #2c3e50;
        margin: 0;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 5px;
        font-size: 1rem;
        transition: border-color 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        border-color: #3498db;
        outline: none;
    }
    .form-group textarea {
        resize: vertical;
        min-height: 100px;
    }
    .checkbox-group {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .checkbox-group input[type="checkbox"] {
        width: auto;
        margin: 0;
    }
    .btn-submit {
        background-color: #27ae60;
        color: white;
        padding: 14px 30px;
        border: none;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .btn-submit:hover {
        background-color: #229954;
    }
    .btn-cancel {
        background-color: #95a5a6;
        color: white;
        padding: 14px 30px;
        border: none;
        border-radius: 5px;
        font-size: 1.1rem;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        margin-left: 10px;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #3498db;
        text-decoration: none;
        font-weight: 600;
    }
    .back-link:hover {
        text-decoration: underline;
    }
    .required {
        color: #e74c3c;
    }
    .current-image {
        max-width: 200px;
        border-radius: 8px;
        margin-top: 10px;
    }
    #imagePreview {
        margin-top: 10px;
    }
    #imagePreview img {
        max-width: 300px;
        border-radius: 8px;
    }
</style>

<div class="admin-container">
    <a href="${pageContext.request.contextPath}/ManageServicesController" class="back-link">← Back to Services</a>
    
    <div class="form-card">
        <div class="form-header">
            <h2>Edit Service</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/ManageServicesController" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="service_id" value="<%= service.get("service_id") %>">
            
            <div class="form-group">
                <label>Service Name <span class="required">*</span></label>
                <input type="text" name="service_name" value="<%= service.get("service_name") %>" required>
            </div>

            <div class="form-group">
                <label>Category <span class="required">*</span></label>
                <select name="category_id" required>
                    <% for(Map<String, Object> category : categories) { %>
                        <option value="<%= category.get("category_id") %>"
                                <%= category.get("category_id").equals(service.get("category_id")) ? "selected" : "" %>>
                            <%= category.get("category_name") %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"><%= service.get("description") != null ? service.get("description") : "" %></textarea>
            </div>

            <div class="form-group">
                <label>Price (SGD) <span class="required">*</span></label>
                <input type="number" name="price" step="0.01" min="0" value="<%= service.get("price") %>" required>
            </div>

            <div class="form-group">
                <label>Duration (minutes) <span class="required">*</span></label>
                <input type="number" name="duration" min="15" step="15" value="<%= service.get("duration") %>" required>
            </div>

            <div class="form-group">
                <label>Current Image</label>
                <% 
                    String currentImageUrl = (String) service.get("image_url");
                    if (currentImageUrl != null && !currentImageUrl.isEmpty()) {
                        if (currentImageUrl.startsWith("/")) {
                            currentImageUrl = currentImageUrl.substring(1);
                        }
                %>
                    <br>
                    <img src="${pageContext.request.contextPath}/<%= currentImageUrl %>" 
                         class="current-image"
                         alt="Current service image"
                         onerror="this.src='${pageContext.request.contextPath}/images/default-service.jpg'">
                <% } else { %>
                    <p style="color: #7f8c8d;">No image uploaded</p>
                <% } %>
            </div>

            <div class="form-group">
                <label>Upload New Image (optional)</label>
                <input type="file" name="service_image" accept="image/*" 
                       onchange="previewImage(this)">
                <div id="imagePreview"></div>
                <small style="color: #7f8c8d;">Leave empty to keep current image. Or provide image URL:</small>
                <input type="text" name="image_url" placeholder="https://example.com/image.jpg" style="margin-top: 10px;">
            </div>

            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" name="is_active" id="is_active" 
                           <%= (Boolean)service.get("is_active") ? "checked" : "" %>>
                    <label for="is_active" style="margin: 0;">Active (Available for booking)</label>
                </div>
            </div>

            <div style="margin-top: 30px;">
                <button type="submit" class="btn-submit">Update Service</button>
                <a href="${pageContext.request.contextPath}/ManageServicesController" class="btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
function previewImage(input) {
    var preview = document.getElementById('imagePreview');
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = '<img src="' + e.target.result + '" style="max-width: 300px; border-radius: 8px; margin-top: 10px;">';
        }
        reader.readAsDataURL(input.files[0]);
    }
}
</script>

<%@ include file="/includes/footer.jsp" %>
