package com.shopsphere.controller;

import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.User;
import com.shopsphere.model.WishlistItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        try {
            List<WishlistItem> wishlist = wishlistDAO.findByUserId(user.getUserId());
            req.setAttribute("wishlist", wishlist);
            req.getRequestDispatcher("/wishlist.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading wishlist: " + e.getMessage());
            req.getRequestDispatcher("/wishlist.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        try {
            int productId = Integer.parseInt(req.getParameter("productId"));
            if ("add".equalsIgnoreCase(action)) {
                wishlistDAO.add(user.getUserId(), productId);
            } else if ("remove".equalsIgnoreCase(action)) {
                wishlistDAO.remove(user.getUserId(), productId);
            }
        } catch (Exception ignored) {}

        String referer = req.getHeader("referer");
        if (referer != null) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/wishlist");
        }
    }
}
