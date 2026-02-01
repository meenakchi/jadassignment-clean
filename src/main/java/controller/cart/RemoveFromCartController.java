package controller.cart;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * RemoveFromCartController - Removes item from cart
 */
@WebServlet("/RemoveFromCartController")
public class RemoveFromCartController extends HttpServlet {
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

        String cartIdParam = request.getParameter("cart_id");

        if (cartIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=invalid");
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdParam);
            boolean success = cartDAO.removeFromCart(cartId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ViewCartController?removed=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/ViewCartController?error=remove");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=invalid");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewCartController?error=database");
        }
    }
}