package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;

import java.sql.SQLException;
import java.util.List;

public class ProductService {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<Product> getAllActiveProducts() throws SQLException {
        return productDAO.findAll(true);
    }

    public List<Product> getAllProductsForAdmin() throws SQLException {
        return productDAO.findAll(false);
    }

    public List<Product> searchProducts(String query, Integer categoryId, Double minPrice, Double maxPrice, String sortBy) throws SQLException {
        return productDAO.searchAndFilter(query, categoryId, minPrice, maxPrice, sortBy);
    }

    public Product getProductById(int id) throws SQLException {
        return productDAO.findById(id);
    }

    public List<Category> getCategories() throws SQLException {
        return categoryDAO.findAllActive();
    }

    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.findAll();
    }

    public boolean saveProduct(Product product) throws SQLException {
        if (product.getProductId() > 0) {
            return productDAO.update(product);
        } else {
            return productDAO.create(product);
        }
    }

    public boolean deleteProduct(int productId) throws SQLException {
        return productDAO.delete(productId);
    }

    public List<Product> getLowStockProducts(int threshold) throws SQLException {
        return productDAO.findLowStock(threshold);
    }

    public List<Review> getReviews(int productId) throws SQLException {
        return reviewDAO.findByProductId(productId);
    }

    public boolean addReview(int userId, int productId, int rating, String text) throws SQLException {
        Review r = new Review();
        r.setUserId(userId);
        r.setProductId(productId);
        r.setRating(rating);
        r.setReviewText(text);
        return reviewDAO.addReview(r);
    }

    public double getAverageRating(int productId) throws SQLException {
        return reviewDAO.getAverageRating(productId);
    }
}
