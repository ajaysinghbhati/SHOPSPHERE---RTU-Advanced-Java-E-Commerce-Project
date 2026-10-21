package com.shopsphere.controller;

import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/search"})
public class ProductServlet extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("q");
        String categoryParam = req.getParameter("category");
        String minPriceParam = req.getParameter("minPrice");
        String maxPriceParam = req.getParameter("maxPrice");
        String sortBy = req.getParameter("sort");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isEmpty()) {
            try { categoryId = Integer.parseInt(categoryParam); } catch (NumberFormatException ignored) {}
        }

        Double minPrice = null;
        if (minPriceParam != null && !minPriceParam.isEmpty()) {
            try { minPrice = Double.parseDouble(minPriceParam); } catch (NumberFormatException ignored) {}
        }

        Double maxPrice = null;
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            try { maxPrice = Double.parseDouble(maxPriceParam); } catch (NumberFormatException ignored) {}
        }

        try {
            List<Product> products = productService.searchProducts(query, categoryId, minPrice, maxPrice, sortBy);
            List<Category> categories = productService.getCategories();

            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.setAttribute("selectedCategory", categoryId);
            req.setAttribute("query", query);
            req.setAttribute("sortBy", sortBy);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);

            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to retrieve products: " + e.getMessage());
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        }
    }
}
