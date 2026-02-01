package controller.admin;

import dao.AdminDAO;
import model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AdminLoginController")
public class AdminLoginController extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Admin admin = adminDAO.validateLogin(username, password);

            if (admin != null) {
                HttpSession session = request.getSession();
                session.setAttribute("admin_id", admin.getAdminId());
                session.setAttribute("admin_username", admin.getUsername());
                session.setAttribute("admin_name", admin.getFullName());
                session.setAttribute("role", "admin");

                response.sendRedirect(request.getContextPath() + "/AdminDashboardController");
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
        }
    }
}
