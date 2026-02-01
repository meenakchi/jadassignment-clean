
package controller.cart;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * AddToCartController - Handles adding services to cart
 */
@WebServlet("/AddToCartController")
public class AddToCartController extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        int memberId = (Integer) session.getAttribute("member_id");
        String serviceIdParam = request.getParameter("service_id");

        if (serviceIdParam == null || !serviceIdParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/ServicesController?error=invalid");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdParam);
        int quantity = 1; // Default quantity

        try {
            boolean success = cartDAO.addToCart(memberId, serviceId, quantity);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ViewCartController?added=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/ServicesController?error=cart_add");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ServicesController?error=database");
        }
    }
}