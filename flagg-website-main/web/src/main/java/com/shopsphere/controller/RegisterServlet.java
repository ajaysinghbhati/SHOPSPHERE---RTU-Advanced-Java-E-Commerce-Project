package com.shopsphere.controller;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String mobile = req.getParameter("mobile");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.findByEmail(email.trim()) != null) {
                req.setAttribute("error", "Email is already registered. Please login.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setMobile(mobile != null ? mobile.trim() : "");
            user.setPassword(DBUtil.hashPassword(password));
            user.setRole("CUSTOMER");
            user.setStatus("ACTIVE");

            boolean success = userDAO.register(user);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=Account+created+successfully!+Please+sign+in.");
            } else {
                req.setAttribute("error", "Failed to create account. Please try again.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
