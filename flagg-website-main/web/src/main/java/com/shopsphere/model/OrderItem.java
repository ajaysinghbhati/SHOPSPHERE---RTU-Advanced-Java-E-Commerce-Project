package com.shopsphere.model;

import java.io.Serializable;

public class OrderItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;
    private String productBrand;
    private String imageUrl;
    private int quantity;
    private double price;

    public OrderItem() {}

    public OrderItem(int orderItemId, int orderId, int productId, int quantity, double price) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductBrand() { return productBrand; }
    public void setProductBrand(String productBrand) { this.productBrand = productBrand; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getItemTotal() {
        return Math.round((price * quantity) * 100.0) / 100.0;
    }
}
