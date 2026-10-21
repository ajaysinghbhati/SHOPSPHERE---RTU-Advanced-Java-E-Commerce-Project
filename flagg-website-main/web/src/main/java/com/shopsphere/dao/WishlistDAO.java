package com.shopsphere.dao;

import com.shopsphere.model.Product;
import com.shopsphere.model.WishlistItem;
import com.shopsphere.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public List<WishlistItem> findByUserId(int userId) throws SQLException {
        List<WishlistItem> list = new ArrayList<>();
        String sql = "SELECT w.*, p.name, p.brand, p.price, p.discount, p.stock, p.image_url, p.status " +
                     "FROM wishlist w JOIN products p ON w.product_id = p.product_id " +
                     "WHERE w.user_id = ? ORDER BY w.wishlist_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WishlistItem item = new WishlistItem();
                    item.setWishlistId(rs.getInt("wishlist_id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setProductId(rs.getInt("product_id"));
                    try { item.setCreatedAt(rs.getTimestamp("created_at")); } catch (Exception ignored) {}

                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));
                    p.setDiscount(rs.getDouble("discount"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setStatus("ACTIVE".equalsIgnoreCase(rs.getString("status")));

                    item.setProduct(p);
                    list.add(item);
                }
            }
        }
        return list;
    }

    public boolean add(int userId, int productId) throws SQLException {
        // Prevent duplicate
        String checkSql = "SELECT wishlist_id FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true; // Already in wishlist
                }
            }
        }

        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean remove(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isInWishlist(int userId, int productId) throws SQLException {
        String sql = "SELECT wishlist_id FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
