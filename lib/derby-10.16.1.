-- =====================================================================
-- ShopSphere: Advanced Java E-Commerce Management System
-- RTU Syllabus Project Database Script (MySQL)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS shopsphere;
USE shopsphere;

-- 1. Users table (Customer & Admin roles)
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    mobile VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- 'CUSTOMER', 'ADMIN'
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Addresses table
CREATE TABLE IF NOT EXISTS addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    address_type VARCHAR(20) DEFAULT 'HOME', -- 'HOME', 'WORK', 'OTHER'
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. Categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- 4. Products table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- 5. Cart table
CREATE TABLE IF NOT EXISTS cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    UNIQUE KEY user_product_unique (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Wishlist table
CREATE TABLE IF NOT EXISTS wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY user_wishlist_unique (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 7. Orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_id INT,
    total_amount DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0.00,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    order_status VARCHAR(50) DEFAULT 'PLACED', -- 'PLACED', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 8. Order items table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- 9. Payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'SUCCESS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 10. Reviews table
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 11. Coupons table
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL, -- 'PERCENTAGE', 'FLAT'
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order DECIMAL(10,2) DEFAULT 0.00,
    maximum_discount DECIMAL(10,2) DEFAULT 5000.00,
    expiry_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- 12. Coupon usage table
CREATE TABLE IF NOT EXISTS coupon_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- =====================================================================
-- SEED DATA (Default demo accounts, categories, products, coupons)
-- Passwords stored in SHA-256:
-- 'admin123'  -> '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9'
-- 'user123'   -> 'e6c279f628c0b29864da5943f55cfa790ae470de239762cf1d1b54a2ddff4319'
-- =====================================================================

INSERT IGNORE INTO users (user_id, name, email, password, mobile, role, status) VALUES
(1, 'Administrator', 'admin@shopsphere.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '9876543210', 'ADMIN', 'ACTIVE'),
(2, 'Rahul Sharma', 'customer@shopsphere.com', 'e6c279f628c0b29864da5943f55cfa790ae470de239762cf1d1b54a2ddff4319', '9812345678', 'CUSTOMER', 'ACTIVE'),
(3, 'Priya Patel', 'priya@shopsphere.com', 'e6c279f628c0b29864da5943f55cfa790ae470de239762cf1d1b54a2ddff4319', '9823456789', 'CUSTOMER', 'ACTIVE');

INSERT IGNORE INTO addresses (address_id, user_id, address_line, city, state, pincode, address_type) VALUES
(1, 2, 'Flat 402, Sunshine Heights, Malviya Nagar', 'Jaipur', 'Rajasthan', '302017', 'HOME'),
(2, 3, 'House 15, Civil Lines', 'Kota', 'Rajasthan', '324001', 'HOME');

INSERT IGNORE INTO categories (category_id, name, description, status) VALUES
(1, 'Electronics', 'Smartphones, laptops, smartwatches, and headphones', 'ACTIVE'),
(2, 'Fashion', 'Apparel, footwear, and designer accessories', 'ACTIVE'),
(3, 'Home & Living', 'Furniture, decor, lighting, and kitchenware', 'ACTIVE'),
(4, 'Books & Study', 'Engineering textbooks, competitive exam books, and stationery', 'ACTIVE');

INSERT IGNORE INTO products (product_id, category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
(1, 1, 'MacBook Air M2 13-inch', 'Apple', 'Midnight color, 8GB Unified RAM, 256GB SSD storage, Liquid Retina display', 94900.00, 10.00, 15, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', 'ACTIVE'),
(2, 1, 'Sony WH-1000XM5 ANC Headphones', 'Sony', 'Industry leading noise cancellation, 30 hours battery, premium crystal clear audio', 29990.00, 15.00, 25, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'ACTIVE'),
(3, 1, 'Samsung Galaxy S24 Ultra 5G', 'Samsung', 'Titanium Gray, 12GB RAM, 256GB storage, Galaxy AI enabled with S-Pen', 124999.00, 8.00, 12, 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500', 'ACTIVE'),
(4, 1, 'Logitech MX Master 3S Mouse', 'Logitech', 'Quiet clicks, 8K DPI sensor on glass, ergonomic multi-device Bluetooth mouse', 8995.00, 5.00, 40, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500', 'ACTIVE'),
(5, 2, 'Classic Denim Jacket', 'Levis', 'Vintage blue denim jacket with regular fit and metal shank buttons', 4599.00, 20.00, 30, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500', 'ACTIVE'),
(6, 2, 'Nike Air Jordan 1 Retro', 'Nike', 'High-top iconic sneakers in black/white/red colorway with premium leather', 14995.00, 0.00, 8, 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500', 'ACTIVE'),
(7, 3, 'Ergonomic Mesh Office Chair', 'Green Soul', 'High-back ergonomic design with breathable mesh and 3D adjustable armrests', 11499.00, 25.00, 18, 'https://images.unsplash.com/photo-1580481077114-1e089d885a50?w=500', 'ACTIVE'),
(8, 3, 'Minimalist Wooden Desk Lamp', 'Philips', 'Warm ambient LED lighting with touch dimmer and wireless phone charger base', 2499.00, 15.00, 45, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500', 'ACTIVE'),
(9, 4, 'Core Java: Advanced Features (Vol 2)', 'Cay Horstmann', 'Comprehensive coverage of Swing, Networking, RMI, JDBC, and Enterprise APIs', 1199.00, 10.00, 50, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=500', 'ACTIVE'),
(10, 4, 'Design Patterns: Gang of Four', 'Addison-Wesley', 'Elements of Reusable Object-Oriented Software classic guide for software engineers', 899.00, 12.00, 35, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500', 'ACTIVE');

INSERT IGNORE INTO coupons (coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES
(1, 'WELCOME10', 'PERCENTAGE', 10.00, 1000.00, 1500.00, '2027-12-31', 'ACTIVE'),
(2, 'RTU500', 'FLAT', 500.00, 3000.00, 500.00, '2027-12-31', 'ACTIVE'),
(3, 'FESTIVE20', 'PERCENTAGE', 20.00, 5000.00, 3000.00, '2027-12-31', 'ACTIVE');

INSERT IGNORE INTO reviews (review_id, user_id, product_id, rating, review_text) VALUES
(1, 2, 1, 5, 'Superb build quality and incredible battery life! Perfect for college coding assignments.'),
(2, 3, 2, 5, 'Unbelievable noise cancelling in metro/bus. Sound stage is wide and rich.'),
(3, 2, 9, 4, 'Essential reference for RTU syllabus! Covers RMI, sockets and database thoroughly.');
