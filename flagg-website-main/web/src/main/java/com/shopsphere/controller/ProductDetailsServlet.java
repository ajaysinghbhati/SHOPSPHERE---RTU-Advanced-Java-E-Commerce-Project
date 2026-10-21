package com.shopsphere.controller;

import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;
import com.shopsphere.model.User;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-details")
public class ProductDetailsServlet extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productService.getProductById(productId);

            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/products?error=Product+not+found");
                return;
            }

            List<Review> reviews = productService.getReviews(productId);
            double avgRating = productService.getAverageRating(productId);

            HttpSession session = req.getSession(false);
            boolean inWishlist = false;
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                inWishlist = wishlistDAO.isInWishlist(user.getUserId(), productId);
            }

            // Cookie demonstration: Remember recently viewed product ID
            Cookie recentCookie = new Cookie("lastViewedProductId", String.valueOf(productId));
            recentCookie.setMaxAge(24 * 60 * 60); // 1 day
            resp.addCookie(recentCookie);

            req.setAttribute("product", product);
            req.setAttribute("reviews", reviews);
            req.setAttribute("avgRating", avgRating);
            req.setAttribute("inWishlist", inWishlist);

            req.getRequestDispatcher("/product-details.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/products");
        }
    }
}
