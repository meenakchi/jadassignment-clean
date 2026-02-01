package controller.cart;

import dao.CartDAO;
import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * ViewCartController - Displays shopping cart
 */
@WebServlet("/ViewCartController")
public class ViewCartController extends HttpServlet {
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

        try {
            List<CartItem> cartItems = cartDAO.getCartItemsByMemberId(memberId);
            BigDecimal cartTotal = cartDAO.getCartTotal(memberId);
            int itemCount = cartDAO.getCartItemCount(memberId);

            // Calculate GST (8% for Singapore)
            BigDecimal gst = cartTotal.multiply(new BigDecimal("0.08"));
            BigDecimal totalWithGST = cartTotal.add(gst);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("cartTotal", cartTotal);
            request.setAttribute("gst", gst);
            request.setAttribute("totalWithGST", totalWithGST);
            request.setAttribute("itemCount", itemCount);

            request.getRequestDispatcher("/views/cart/viewCart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading cart: " + e.getMessage());
            request.getRequestDispatcher("/views/cart/viewCart.jsp").forward(request, response);
        }
    }
}
