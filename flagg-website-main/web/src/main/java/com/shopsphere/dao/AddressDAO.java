package com.shopsphere.dao;

import com.shopsphere.model.Address;
import com.shopsphere.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public List<Address> findByUserId(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY address_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAddress(rs));
                }
            }
        }
        return list;
    }

    public Address findById(int addressId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        }
        return null;
    }

    public boolean create(Address addr) throws SQLException {
        String sql = "INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, addr.getUserId());
            ps.setString(2, addr.getAddressLine());
            ps.setString(3, addr.getCity());
            ps.setString(4, addr.getState());
            ps.setString(5, addr.getPincode());
            ps.setString(6, addr.getAddressType() != null ? addr.getAddressType() : "HOME");
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        addr.setAddressId(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean delete(int addressId, int userId) throws SQLException {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    private Address mapAddress(ResultSet rs) throws SQLException {
        return new Address(
            rs.getInt("address_id"),
            rs.getInt("user_id"),
            rs.getString("address_line"),
            rs.getString("city"),
            rs.getString("state"),
            rs.getString("pincode"),
            rs.getString("address_type")
        );
    }
}
