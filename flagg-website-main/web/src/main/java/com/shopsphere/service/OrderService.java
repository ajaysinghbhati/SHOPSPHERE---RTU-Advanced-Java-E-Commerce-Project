package com.shopsphere.service;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;

import java.sql.SQLException;
import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public List<Order> getUserOrders(int userId) throws SQLException {
        return orderDAO.findByUserId(userId);
    }

    public Order getOrderDetails(int orderId) throws SQLException {
        return orderDAO.findById(orderId);
    }

    public List<Order> getAllOrders() throws SQLException {
        return orderDAO.findAll();
    }

    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException {
        Order o = orderDAO.findById(orderId);
        if (o == null) return false;

        // If transitioning to CANCELLED, restore stock
        if ("CANCELLED".equalsIgnoreCase(newStatus) && !"CANCELLED".equalsIgnoreCase(o.getOrderStatus())) {
            for (OrderItem item : o.getItems()) {
                productDAO.updateStock(item.getProductId(), item.getQuantity());
            }
        }
        return orderDAO.updateStatus(orderId, newStatus);
    }

    public double getTotalRevenue() throws SQLException {
        return orderDAO.getTotalRevenue();
    }

    public int getTotalOrderCount() throws SQLException {
        return orderDAO.getTotalOrderCount();
    }
}
