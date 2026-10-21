package com.shopsphere.util;

import java.io.File;
import java.io.InputStream;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database Connection Utility.
 * Supports MySQL (default for syllabus) and seamlessly falls back to embedded Apache Derby
 * if MySQL server is offline or authentication fails, ensuring zero-config out-of-the-box readiness.
 */
public class DBUtil {

    private static String dbType = "UNKNOWN"; // "MYSQL" or "DERBY"
    private static String mysqlUrl = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String mysqlUser = "root";
    private static String mysqlPass = "root";

    private static final String DERBY_URL = "jdbc:derby:shopspheredb;create=true";

    static {
        loadConfig();
        initDatabase();
    }

    private static void loadConfig() {
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                if (props.getProperty("db.url") != null) mysqlUrl = props.getProperty("db.url");
                if (props.getProperty("db.user") != null) mysqlUser = props.getProperty("db.user");
                if (props.getProperty("db.password") != null) mysqlPass = props.getProperty("db.password");
            }
        } catch (Exception ignored) {}
    }

    public static synchronized Connection getConnection() throws SQLException {
        // 1. Try MySQL first
        if (!"DERBY".equals(dbType)) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(mysqlUrl, mysqlUser, mysqlPass);
                dbType = "MYSQL";
                return conn;
            } catch (Exception e) {
                if ("MYSQL".equals(dbType)) {
                    throw new SQLException("Failed connecting to MySQL: " + e.getMessage(), e);
                }
                // Fallback to Derby
                dbType = "DERBY";
            }
        }

        // 2. Embedded Derby fallback
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            return DriverManager.getConnection(DERBY_URL);
        } catch (Exception e) {
            throw new SQLException("Failed connecting to embedded database: " + e.getMessage(), e);
        }
    }

    public static String getActiveDatabaseType() {
        return dbType;
    }

    /**
     * Automatically creates tables and seeds demo data on initial launch
     */
    public static void initDatabase() {
        try (Connection conn = getConnection()) {
            if ("DERBY".equals(dbType)) {
                initDerbyTables(conn);
            }
        } catch (Exception e) {
            System.err.println("Database init warning: " + e.getMessage());
        }
    }

    private static void initDerbyTables(Connection conn) {
        // Check if users table exists in Derby
        try (Statement st = conn.createStatement()) {
            st.executeQuery("SELECT COUNT(*) FROM users");
            return; // Table exists
        } catch (Exception notExist) {
            // Need to create tables in Derby
            System.out.println("[DBUtil] Initializing embedded Apache Derby schema & demo data...");
        }

        String[] ddl = {
            "CREATE TABLE users (user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(120) NOT NULL UNIQUE, password VARCHAR(255) NOT NULL, mobile VARCHAR(20), role VARCHAR(20) DEFAULT 'CUSTOMER', status VARCHAR(20) DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE addresses (address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, user_id INT NOT NULL, address_line VARCHAR(255) NOT NULL, city VARCHAR(100) NOT NULL, state VARCHAR(100) NOT NULL, pincode VARCHAR(20) NOT NULL, address_type VARCHAR(20) DEFAULT 'HOME')",
            "CREATE TABLE categories (category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE, description VARCHAR(1000), status VARCHAR(20) DEFAULT 'ACTIVE')",
            "CREATE TABLE products (product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, category_id INT NOT NULL, name VARCHAR(200) NOT NULL, brand VARCHAR(100), description VARCHAR(2000), price DOUBLE NOT NULL, discount DOUBLE DEFAULT 0.0, stock INT DEFAULT 0, image_url VARCHAR(500), status VARCHAR(20) DEFAULT 'ACTIVE', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE cart (cart_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, quantity INT DEFAULT 1)",
            "CREATE TABLE wishlist (wishlist_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE orders (order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, user_id INT NOT NULL, address_id INT, total_amount DOUBLE NOT NULL, discount DOUBLE DEFAULT 0.0, payment_method VARCHAR(50) NOT NULL, payment_status VARCHAR(50) DEFAULT 'PENDING', order_status VARCHAR(50) DEFAULT 'PLACED', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE order_items (order_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL, quantity INT NOT NULL, price DOUBLE NOT NULL)",
            "CREATE TABLE payments (payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, order_id INT NOT NULL, payment_method VARCHAR(50) NOT NULL, transaction_reference VARCHAR(100), amount DOUBLE NOT NULL, payment_status VARCHAR(50) DEFAULT 'SUCCESS', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE reviews (review_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, rating INT NOT NULL, review_text VARCHAR(2000), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)",
            "CREATE TABLE coupons (coupon_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, code VARCHAR(50) NOT NULL UNIQUE, discount_type VARCHAR(20) NOT NULL, discount_value DOUBLE NOT NULL, minimum_order DOUBLE DEFAULT 0.0, maximum_discount DOUBLE DEFAULT 5000.0, expiry_date DATE, status VARCHAR(20) DEFAULT 'ACTIVE')",
            "CREATE TABLE coupon_usage (usage_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, coupon_id INT NOT NULL, user_id INT NOT NULL, order_id INT NOT NULL, used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
        };

        for (String sql : ddl) {
            try (Statement st = conn.createStatement()) {
                st.execute(sql);
            } catch (Exception e) {
                System.err.println("DDL warning: " + e.getMessage());
            }
        }

        seedData(conn);
    }

    private static void seedData(Connection conn) {
        String adminPass = hashPassword("admin123");
        String userPass = hashPassword("user123");

        try (Statement st = conn.createStatement()) {
            st.executeUpdate("INSERT INTO users (name, email, password, mobile, role, status) VALUES ('Administrator', 'admin@shopsphere.com', '" + adminPass + "', '9876543210', 'ADMIN', 'ACTIVE')");
            st.executeUpdate("INSERT INTO users (name, email, password, mobile, role, status) VALUES ('Rahul Sharma', 'customer@shopsphere.com', '" + userPass + "', '9812345678', 'CUSTOMER', 'ACTIVE')");
            st.executeUpdate("INSERT INTO users (name, email, password, mobile, role, status) VALUES ('Priya Patel', 'priya@shopsphere.com', '" + userPass + "', '9823456789', 'CUSTOMER', 'ACTIVE')");

            st.executeUpdate("INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type) VALUES (2, 'Flat 402, Sunshine Heights, Malviya Nagar', 'Jaipur', 'Rajasthan', '302017', 'HOME')");
            st.executeUpdate("INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type) VALUES (3, 'House 15, Civil Lines', 'Kota', 'Rajasthan', '324001', 'HOME')");

            st.executeUpdate("INSERT INTO categories (name, description, status) VALUES ('Electronics', 'Smartphones, laptops, smartwatches, and headphones', 'ACTIVE')");
            st.executeUpdate("INSERT INTO categories (name, description, status) VALUES ('Fashion', 'Apparel, footwear, and designer accessories', 'ACTIVE')");
            st.executeUpdate("INSERT INTO categories (name, description, status) VALUES ('Home & Living', 'Furniture, decor, lighting, and kitchenware', 'ACTIVE')");
            st.executeUpdate("INSERT INTO categories (name, description, status) VALUES ('Books & Study', 'Engineering textbooks, competitive exam books, and stationery', 'ACTIVE')");

            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (1, 'MacBook Air M2 13-inch', 'Apple', 'Midnight color, 8GB Unified RAM, 256GB SSD storage, Liquid Retina display', 94900.0, 10.0, 15, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (1, 'Sony WH-1000XM5 ANC Headphones', 'Sony', 'Industry leading noise cancellation, 30 hours battery, premium crystal clear audio', 29990.0, 15.0, 25, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (1, 'Samsung Galaxy S24 Ultra 5G', 'Samsung', 'Titanium Gray, 12GB RAM, 256GB storage, Galaxy AI enabled with S-Pen', 124999.0, 8.0, 12, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (1, 'Logitech MX Master 3S Mouse', 'Logitech', 'Quiet clicks, 8K DPI sensor on glass, ergonomic multi-device Bluetooth mouse', 8995.0, 5.0, 40, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (2, 'Classic Denim Jacket', 'Levis', 'Vintage blue denim jacket with regular fit and metal shank buttons', 4599.0, 20.0, 30, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (2, 'Nike Air Jordan 1 Retro', 'Nike', 'High-top iconic sneakers in black/white/red colorway with premium leather', 14995.0, 0.0, 8, 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (3, 'Ergonomic Mesh Office Chair', 'Green Soul', 'High-back ergonomic design with breathable mesh and 3D adjustable armrests', 11499.0, 25.0, 18, 'https://images.unsplash.com/photo-1580481077114-1e089d885a50?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (3, 'Minimalist Wooden Desk Lamp', 'Philips', 'Warm ambient LED lighting with touch dimmer and wireless phone charger base', 2499.0, 15.0, 45, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (4, 'Core Java: Advanced Features (Vol 2)', 'Cay Horstmann', 'Comprehensive coverage of Swing, Networking, RMI, JDBC, and Enterprise APIs', 1199.0, 10.0, 50, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=500', 'ACTIVE')");
            st.executeUpdate("INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES (4, 'Design Patterns: Gang of Four', 'Addison-Wesley', 'Elements of Reusable Object-Oriented Software classic guide for software engineers', 899.0, 12.0, 35, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500', 'ACTIVE')");

            st.executeUpdate("INSERT INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES ('WELCOME10', 'PERCENTAGE', 10.0, 1000.0, 1500.0, DATE('2028-12-31'), 'ACTIVE')");
            st.executeUpdate("INSERT INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES ('RTU500', 'FLAT', 500.0, 3000.0, 500.0, DATE('2028-12-31'), 'ACTIVE')");
            st.executeUpdate("INSERT INTO coupons (code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES ('FESTIVE20', 'PERCENTAGE', 20.0, 5000.0, 3000.0, DATE('2028-12-31'), 'ACTIVE')");

            st.executeUpdate("INSERT INTO reviews (user_id, product_id, rating, review_text) VALUES (2, 1, 5, 'Superb build quality and incredible battery life! Perfect for college coding assignments.')");
            st.executeUpdate("INSERT INTO reviews (user_id, product_id, rating, review_text) VALUES (3, 2, 5, 'Unbelievable noise cancelling in metro/bus. Sound stage is wide and rich.')");
            st.executeUpdate("INSERT INTO reviews (user_id, product_id, rating, review_text) VALUES (2, 9, 4, 'Essential reference for RTU syllabus! Covers RMI, sockets and database thoroughly.')");
            System.out.println("[DBUtil] Embedded database schema & seed data initialized successfully.");
        } catch (Exception e) {
            System.err.println("Seed data warning: " + e.getMessage());
        }
    }

    /**
     * SHA-256 secure password hashing as required in security specs
     */
    public static String hashPassword(String plain) {
        if (plain == null) return null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(plain.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try { c.close(); } catch (Exception ignored) {}
            }
        }
    }
}
