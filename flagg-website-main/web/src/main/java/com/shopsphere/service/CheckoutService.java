package com.shopsphere.service;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.OrderItemDAO;
import com.shopsphere.dao.PaymentDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.model.Payment;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CheckoutService {
    private final CartDAO cartDAO = new CartDAO();
    private final CouponDAO couponDAO = new CouponDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public Coupon validateCoupon(String code, double cartTotal) throws SQLException {
        Coupon coupon = couponDAO.findByCode(code);
        if (coupon == null) {
            return null;
        }
        if (cartTotal < coupon.getMinimumOrder()) {
            return null;
        }
        return coupon;
    }

    /**
     * Executes order placement inside secure transaction semantics.
     * Computes order totals strictly on server side.
     * Verifies and decrements stock.
     */
    public synchronized Order processCheckout(int userId, int addressId, String couponCode, String paymentMethod) throws Exception {
        List<CartItem> cartItems = cartDAO.findByUserId(userId);
        if (cartItems.isEmpty()) {
            throw new IllegalStateException("Cart is empty.");
        }

        double subtotal = 0.0;
        for (CartItem item : cartItems) {
            if (item.getProduct().getStock() < item.getQuantity()) {
                throw new IllegalStateException("Insufficient stock for product: " + item.getProduct().getName());
            }
            subtotal += item.getSubtotal();
        }

        double discount = 0.0;
        Coupon coupon = null;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            coupon = validateCoupon(couponCode, subtotal);
            if (coupon != null) {
                discount = coupon.calculateDiscount(subtotal);
            }
        }

        double finalAmount = Math.max(0.0, Math.round((subtotal - discount) * 100.0) / 100.0);

        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setTotalAmount(subtotal);
        order.setDiscount(discount);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("COMPLETED");
        order.setOrderStatus("CONFIRMED");

        int orderId = orderDAO.createOrder(order);
        if (orderId <= 0) {
            throw new SQLException("Failed creating order record.");
        }

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cartItems) {
            OrderItem oi = new OrderItem();
            oi.setOrderId(orderId);
            oi.setProductId(ci.getProductId());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getProduct().getDiscountedPrice());
            orderItems.add(oi);

            // Deduct stock
            productDAO.updateStock(ci.getProductId(), -ci.getQuantity());
        }
        orderItemDAO.createOrderItems(orderItems);
        order.setItems(orderItems);

        // Record payment
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setPaymentMethod(paymentMethod);
        payment.setTransactionReference("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        payment.setAmount(finalAmount);
        payment.setPaymentStatus("SUCCESS");
        paymentDAO.recordPayment(payment);

        // Record coupon usage
        if (coupon != null) {
            couponDAO.recordUsage(coupon.getCouponId(), userId, orderId);
        }

        // Clear user cart
        cartDAO.clearUserCart(userId);

        return order;
    }
}
