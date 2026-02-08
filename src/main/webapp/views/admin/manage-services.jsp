<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Service" %>
<%@ include file="/includes/header.jsp" %>

<div class="admin-container">
    <div class="page-header">
        <h2>Manage Services</h2>
        <a href="addServices.jsp" class="btn-add">+ Add New Service</a>
    </div>

    <div class="services-table">
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Service Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Service> services = (List<Service>) request.getAttribute("services");
                    if(services != null) {
                        for(Service s : services) { 
                %>
                <tr>
                    <td>
                        <img src="${pageContext.request.contextPath}/<%= s.getImageUrl() %>" 
                             style="width:50px; height:50px; object-fit:cover;">
                    </td>
                    <td><%= s.getServiceName() %></td>
                    <td><%= s.getCategoryName() %></td>
                    <td>$<%= s.getPrice() %></td>
                    <td>
                        <span class="status-badge <%= s.isActive() ? "status-active" : "status-inactive" %>">
                            <%= s.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </td>
                    <td>
                        <a href="ManageServicesController?action=toggle&id=<%= s.getServiceId() %>" class="action-btn btn-toggle">Toggle</a>
                        <a href="ManageServicesController?action=delete&id=<%= s.getServiceId() %>" 
                           class="action-btn btn-delete" onclick="return confirm('Delete?')">Delete</a>
                    </td>
                </tr>
                <%      } 
                    } 
                %>
            </tbody>
        </table>
    </div>
</div>