package controller.cart;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * UpdateCartController - Updates cart item quantity
 */
@WebServlet("/UpdateCartController")
public class UpdateCartController extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("member_id") == null) {
            response.sendRedirect(request.getContextPath() + "/MemberLoginController");
            return;
        }

        String cartIdParam = request.getParameter("cart_id");
        String quantityParam = request.getParameter("quantity");

        if (cartIdParam == null || quantityParam == null) {
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=invalid");
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdParam);
            int quantity = Integer.parseInt(quantityParam);

            if (quantity <= 0) {
                // Remove item if quantity is 0 or negative
                cartDAO.removeFromCart(cartId);
            } else {
                cartDAO.updateCartQuantity(cartId, quantity);
            }

            response.sendRedirect(request.getContextPath() + "/ViewCartController?updated=success");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=invalid");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=database");
        }
    }
}
