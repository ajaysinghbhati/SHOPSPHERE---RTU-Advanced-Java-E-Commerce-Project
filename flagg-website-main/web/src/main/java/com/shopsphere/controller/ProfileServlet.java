package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.User;
import com.shopsphere.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");

        try {
            User user = userDAO.findById(sessionUser.getUserId());
            List<Address> addresses = addressDAO.findByUserId(user.getUserId());

            req.setAttribute("user", user);
            req.setAttribute("addresses", addresses);
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading profile: " + e.getMessage());
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        try {
            if ("updateProfile".equalsIgnoreCase(action)) {
                String name = req.getParameter("name");
                String mobile = req.getParameter("mobile");

                sessionUser.setName(name);
                sessionUser.setMobile(mobile);
                userDAO.updateProfile(sessionUser);
                session.setAttribute("user", sessionUser);
                resp.sendRedirect(req.getContextPath() + "/profile?msg=Profile+updated+successfully");
                return;
            } else if ("changePassword".equalsIgnoreCase(action)) {
                String oldPass = req.getParameter("oldPassword");
                String newPass = req.getParameter("newPassword");
                String confirmPass = req.getParameter("confirmPassword");

                User current = userDAO.findById(sessionUser.getUserId());
                if (!current.getPassword().equals(DBUtil.hashPassword(oldPass))) {
                    resp.sendRedirect(req.getContextPath() + "/profile?error=Current+password+is+incorrect");
                    return;
                }
                if (!newPass.equals(confirmPass)) {
                    resp.sendRedirect(req.getContextPath() + "/profile?error=New+passwords+do+not+match");
                    return;
                }

                userDAO.updatePassword(sessionUser.getUserId(), DBUtil.hashPassword(newPass));
                resp.sendRedirect(req.getContextPath() + "/profile?msg=Password+changed+successfully");
                return;
            } else if ("addAddress".equalsIgnoreCase(action)) {
                Address addr = new Address();
                addr.setUserId(sessionUser.getUserId());
                addr.setAddressLine(req.getParameter("addressLine"));
                addr.setCity(req.getParameter("city"));
                addr.setState(req.getParameter("state"));
                addr.setPincode(req.getParameter("pincode"));
                addr.setAddressType(req.getParameter("addressType"));
                addressDAO.create(addr);
                resp.sendRedirect(req.getContextPath() + "/profile?msg=Address+added+successfully");
                return;
            } else if ("deleteAddress".equalsIgnoreCase(action)) {
                int addressId = Integer.parseInt(req.getParameter("addressId"));
                addressDAO.delete(addressId, sessionUser.getUserId());
                resp.sendRedirect(req.getContextPath() + "/profile?msg=Address+deleted");
                return;
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/profile?error=" + e.getMessage());
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}
