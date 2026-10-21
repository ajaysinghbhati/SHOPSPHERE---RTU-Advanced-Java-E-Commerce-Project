package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        try {
            List<CartItem> cartItems = cartDAO.findByUserId(user.getUserId());
            double total = 0.0;
            for (CartItem item : cartItems) {
                total += item.getSubtotal();
            }

            // Sync cart count in session
            session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", Math.round(total * 100.0) / 100.0);
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading cart: " + e.getMessage());
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = 1;
                try {
                    String qParam = req.getParameter("quantity");
                    if (qParam != null) quantity = Integer.parseInt(qParam);
                } catch (Exception ignored) {}
                cartDAO.addToCart(user.getUserId(), productId, quantity);
            } else if ("update".equalsIgnoreCase(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cartDAO.updateQuantity(cartId, quantity);
            } else if ("remove".equalsIgnoreCase(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                cartDAO.deleteItem(cartId);
            }

            session.setAttribute("cartCount", cartDAO.getCartCount(user.getUserId()));
        } catch (Exception e) {
            req.getSession().setAttribute("errorMsg", "Cart action error: " + e.getMessage());
        }

        String referer = req.getHeader("referer");
        if (referer != null && referer.contains("product-details")) {
            resp.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + "added=true");
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
