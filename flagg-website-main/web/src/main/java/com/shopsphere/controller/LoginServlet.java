package com.shopsphere.controller;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try {
            String hashed = DBUtil.hashPassword(password.trim());
            User user = userDAO.authenticate(email.trim(), hashed);

            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());

                // Cookie demo for remembering user email (never passwords!)
                if ("on".equalsIgnoreCase(remember)) {
                    Cookie userCookie = new Cookie("savedEmail", user.getEmail());
                    userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                    resp.addCookie(userCookie);
                }

                String redirect = (String) session.getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    resp.sendRedirect(redirect);
                } else if (user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/products");
                }
            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Authentication error: " + e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
