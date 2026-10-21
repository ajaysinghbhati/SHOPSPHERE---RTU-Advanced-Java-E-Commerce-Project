package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.CartDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final AddressDAO addressDAO = new AddressDAO();
    private final CheckoutService checkoutService = new CheckoutService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        try {
            List<CartItem> cartItems = cartDAO.findByUserId(user.getUserId());
            if (cartItems.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart?msg=Your+cart+is+empty");
                return;
            }

            double subtotal = 0.0;
            for (CartItem item : cartItems) {
                subtotal += item.getSubtotal();
            }

            List<Address> addresses = addressDAO.findByUserId(user.getUserId());

            String couponCode = req.getParameter("coupon");
            double discount = 0.0;
            String couponMessage = null;

            if (couponCode != null && !couponCode.trim().isEmpty()) {
                Coupon coupon = checkoutService.validateCoupon(couponCode.trim(), subtotal);
                if (coupon != null) {
                    discount = coupon.calculateDiscount(subtotal);
                    couponMessage = "Coupon " + coupon.getCode() + " applied! Saved ₹" + discount;
                    req.setAttribute("appliedCoupon", coupon.getCode());
                } else {
                    couponMessage = "Invalid or expired coupon, or minimum order requirement not met.";
                }
            }

            double total = Math.max(0, Math.round((subtotal - discount) * 100.0) / 100.0);

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("subtotal", Math.round(subtotal * 100.0) / 100.0);
            req.setAttribute("discount", discount);
            req.setAttribute("total", total);
            req.setAttribute("addresses", addresses);
            req.setAttribute("couponMessage", couponMessage);

            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading checkout: " + e.getMessage());
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        String action = req.getParameter("action");

        // Action 1: Add new address during checkout
        if ("addAddress".equalsIgnoreCase(action)) {
            String line = req.getParameter("addressLine");
            String city = req.getParameter("city");
            String state = req.getParameter("state");
            String pincode = req.getParameter("pincode");
            String type = req.getParameter("addressType");

            try {
                Address addr = new Address();
                addr.setUserId(user.getUserId());
                addr.setAddressLine(line);
                addr.setCity(city);
                addr.setState(state);
                addr.setPincode(pincode);
                addr.setAddressType(type != null ? type : "HOME");
                addressDAO.create(addr);
            } catch (Exception ignored) {}

            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // Action 2: Place Order
        String addressIdStr = req.getParameter("addressId");
        String paymentMethod = req.getParameter("paymentMethod");
        String couponCode = req.getParameter("couponCode");

        if (addressIdStr == null || addressIdStr.isEmpty()) {
            req.getSession().setAttribute("errorMsg", "Please select a shipping address.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        try {
            int addressId = Integer.parseInt(addressIdStr);
            Order placedOrder = checkoutService.processCheckout(user.getUserId(), addressId, couponCode, paymentMethod);

            // Update cart count
            session.setAttribute("cartCount", 0);

            // Redirect to success page
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + placedOrder.getOrderId());
        } catch (Exception e) {
            req.getSession().setAttribute("errorMsg", "Failed to place order: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }
}
