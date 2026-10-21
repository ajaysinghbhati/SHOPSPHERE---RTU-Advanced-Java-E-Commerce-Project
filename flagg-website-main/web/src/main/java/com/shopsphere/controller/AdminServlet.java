package com.shopsphere.controller;

import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/products",
    "/admin/product-save",
    "/admin/product-delete",
    "/admin/categories",
    "/admin/category-save",
    "/admin/category-delete",
    "/admin/orders",
    "/admin/order-status",
    "/admin/users",
    "/admin/user-status",
    "/admin/coupons",
    "/admin/coupon-save",
    "/admin/coupon-delete"
})
public class AdminServlet extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final OrderService orderService = new OrderService();
    private final UserDAO userDAO = new UserDAO();
    private final CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/dashboard".equals(path)) {
                // Dashboard stats
                List<Product> products = productService.getAllProductsForAdmin();
                List<Product> lowStock = productService.getLowStockProducts(15);
                double totalRevenue = orderService.getTotalRevenue();
                int totalOrders = orderService.getTotalOrderCount();
                int totalUsers = userDAO.findAll().size();

                req.setAttribute("productCount", products.size());
                req.setAttribute("lowStockCount", lowStock.size());
                req.setAttribute("lowStockProducts", lowStock);
                req.setAttribute("totalRevenue", totalRevenue);
                req.setAttribute("totalOrders", totalOrders);
                req.setAttribute("totalUsers", totalUsers);
                req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
            } else if ("/admin/products".equals(path)) {
                req.setAttribute("products", productService.getAllProductsForAdmin());
                req.setAttribute("categories", productService.getAllCategories());
                req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
            } else if ("/admin/categories".equals(path)) {
                req.setAttribute("categories", productService.getAllCategories());
                req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
            } else if ("/admin/orders".equals(path)) {
                req.setAttribute("orders", orderService.getAllOrders());
                req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
            } else if ("/admin/users".equals(path)) {
                req.setAttribute("users", userDAO.findAll());
                req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
            } else if ("/admin/coupons".equals(path)) {
                req.setAttribute("coupons", couponDAO.findAll());
                req.getRequestDispatcher("/admin/coupons.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Admin error: " + e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        try {
            if ("/admin/product-save".equals(path)) {
                String idStr = req.getParameter("productId");
                int id = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;

                Product p = new Product();
                p.setProductId(id);
                p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                p.setName(req.getParameter("name"));
                p.setBrand(req.getParameter("brand"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                p.setDiscount(Double.parseDouble(req.getParameter("discount")));
                p.setStock(Integer.parseInt(req.getParameter("stock")));
                p.setImageUrl(req.getParameter("imageUrl"));
                p.setStatus("ACTIVE".equalsIgnoreCase(req.getParameter("status")));

                productService.saveProduct(p);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=Product+saved+successfully");
            } else if ("/admin/product-delete".equals(path)) {
                int id = Integer.parseInt(req.getParameter("productId"));
                productService.deleteProduct(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products?msg=Product+deleted");
            } else if ("/admin/category-save".equals(path)) {
                String idStr = req.getParameter("categoryId");
                int id = (idStr != null && !idStr.isEmpty()) ? Integer.parseInt(idStr) : 0;

                Category c = new Category(id, req.getParameter("name"), req.getParameter("description"), req.getParameter("status"));
                if (id > 0) {
                    new com.shopsphere.dao.CategoryDAO().update(c);
                } else {
                    new com.shopsphere.dao.CategoryDAO().create(c);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=Category+saved");
            } else if ("/admin/category-delete".equals(path)) {
                int id = Integer.parseInt(req.getParameter("categoryId"));
                new com.shopsphere.dao.CategoryDAO().delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/categories?msg=Category+deleted");
            } else if ("/admin/order-status".equals(path)) {
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                String status = req.getParameter("status");
                orderService.updateOrderStatus(orderId, status);
                resp.sendRedirect(req.getContextPath() + "/admin/orders?msg=Order+status+updated");
            } else if ("/admin/user-status".equals(path)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String status = req.getParameter("status");
                userDAO.updateStatus(userId, status);
                resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User+status+updated");
            } else if ("/admin/coupon-save".equals(path)) {
                Coupon c = new Coupon();
                c.setCode(req.getParameter("code"));
                c.setDiscountType(req.getParameter("discountType"));
                c.setDiscountValue(Double.parseDouble(req.getParameter("discountValue")));
                c.setMinimumOrder(Double.parseDouble(req.getParameter("minimumOrder")));
                c.setMaximumDiscount(Double.parseDouble(req.getParameter("maximumDiscount")));
                c.setExpiryDate(Date.valueOf(req.getParameter("expiryDate")));
                c.setStatus(req.getParameter("status"));
                couponDAO.create(c);
                resp.sendRedirect(req.getContextPath() + "/admin/coupons?msg=Coupon+created");
            } else if ("/admin/coupon-delete".equals(path)) {
                int id = Integer.parseInt(req.getParameter("couponId"));
                couponDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/coupons?msg=Coupon+deleted");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error=" + e.getMessage());
        }
    }
}
