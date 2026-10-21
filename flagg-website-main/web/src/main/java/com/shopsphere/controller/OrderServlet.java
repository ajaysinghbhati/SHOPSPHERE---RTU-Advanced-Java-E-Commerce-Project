package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        String orderIdStr = req.getParameter("id");

        try {
            if (orderIdStr != null && !orderIdStr.isEmpty()) {
                // View specific order details
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderService.getOrderDetails(orderId);

                // Security: Ensure user owns this order or is admin
                if (order == null || (order.getUserId() != user.getUserId() && !user.isAdmin())) {
                    resp.sendRedirect(req.getContextPath() + "/orders?error=Order+not+found");
                    return;
                }

                req.setAttribute("order", order);
                req.getRequestDispatcher("/order-details.jsp").forward(req, resp);
            } else {
                // View all customer orders
                List<Order> orders = orderService.getUserOrders(user.getUserId());
                req.setAttribute("orders", orders);
                req.getRequestDispatcher("/orders.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error loading orders: " + e.getMessage());
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
        }
    }
}
