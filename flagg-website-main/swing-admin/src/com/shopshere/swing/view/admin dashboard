package com.shopsphere.swing.view;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Order;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

/**
 * RTU Syllabus Swing Admin Dashboard:
 * Demonstrates JFrame, JTabbedPane, JTable, JScrollPane, JComboBox, JTextField,
 * JButton, JCheckBox, JRadioButton, and JOptionPane.
 */
public class AdminDashboard extends JFrame {
    private final User adminUser;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    // Tables
    private JTable productTable;
    private DefaultTableModel productTableModel;
    private JTable orderTable;
    private DefaultTableModel orderTableModel;
    private JTable userTable;
    private DefaultTableModel userTableModel;

    // Product inputs
    private JTextField pIdField;
    private JTextField pNameField;
    private JTextField pBrandField;
    private JTextField pPriceField;
    private JTextField pDiscountField;
    private JTextField pStockField;
    private JComboBox<Category> pCategoryCombo;
    private JCheckBox pActiveCheckbox;

    public AdminDashboard(User adminUser) {
        this.adminUser = adminUser;
        setTitle("Flagg Desktop Management Console - Logged in as: " + adminUser.getName());
        setSize(1000, 700);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        initUI();
        loadAllData();
    }

    private void initUI() {
        JTabbedPane tabbedPane = new JTabbedPane();

        tabbedPane.addTab("📦 Product Management", createProductPanel());
        tabbedPane.addTab("📋 Orders & Fulfillment", createOrderPanel());
        tabbedPane.addTab("👥 Customer Directory", createUserPanel());
        tabbedPane.addTab("⚠️ Low-Stock Inventory Alert", createInventoryPanel());

        JPanel root = new JPanel(new BorderLayout());

        // Header Bar
        JPanel topBar = new JPanel(new BorderLayout());
        topBar.setBackground(new Color(24, 76, 120));
        topBar.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        JLabel title = new JLabel("Flagg Enterprise Administration (Swing MVC)");
        title.setForeground(Color.WHITE);
        title.setFont(new Font("Segoe UI", Font.BOLD, 16));

        JButton logoutBtn = new JButton("Logout");
        logoutBtn.addActionListener(e -> {
            dispose();
            new LoginFrame().setVisible(true);
        });

        topBar.add(title, BorderLayout.WEST);
        topBar.add(logoutBtn, BorderLayout.EAST);

        root.add(topBar, BorderLayout.NORTH);
        root.add(tabbedPane, BorderLayout.CENTER);

        setContentPane(root);
    }

    private JPanel createProductPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Form Panel
        JPanel form = new JPanel(new GridLayout(4, 4, 8, 8));
        form.setBorder(BorderFactory.createTitledBorder("Product Details Form (Add / Edit)"));

        pIdField = new JTextField();
        pIdField.setEditable(false);
        pNameField = new JTextField();
        pBrandField = new JTextField();
        pPriceField = new JTextField();
        pDiscountField = new JTextField("0");
        pStockField = new JTextField();
        pCategoryCombo = new JComboBox<>();
        pActiveCheckbox = new JCheckBox("Active Product", true);

        form.add(new JLabel("Product ID:"));
        form.add(pIdField);
        form.add(new JLabel("Category:"));
        form.add(pCategoryCombo);

        form.add(new JLabel("Name:"));
        form.add(pNameField);
        form.add(new JLabel("Brand:"));
        form.add(pBrandField);

        form.add(new JLabel("Price (₹):"));
        form.add(pPriceField);
        form.add(new JLabel("Discount (%):"));
        form.add(pDiscountField);

        form.add(new JLabel("Stock Quantity:"));
        form.add(pStockField);
        form.add(new JLabel("Status:"));
        form.add(pActiveCheckbox);

        // Buttons
        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton saveBtn = new JButton("Save / Update");
        JButton clearBtn = new JButton("Clear Form");
        JButton deleteBtn = new JButton("Delete Product");

        saveBtn.addActionListener(e -> saveProduct());
        clearBtn.addActionListener(e -> clearProductForm());
        deleteBtn.addActionListener(e -> deleteProduct());

        btnPanel.add(clearBtn);
        btnPanel.add(deleteBtn);
        btnPanel.add(saveBtn);

        JPanel topContainer = new JPanel(new BorderLayout());
        topContainer.add(form, BorderLayout.CENTER);
        topContainer.add(btnPanel, BorderLayout.SOUTH);

        // Table
        String[] columns = {"ID", "Name", "Brand", "Price", "Discount", "Stock", "Category", "Status"};
        productTableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        productTable = new JTable(productTableModel);
        productTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        productTable.getSelectionModel().addListSelectionListener(e -> {
            int row = productTable.getSelectedRow();
            if (row >= 0) {
                pIdField.setText(productTableModel.getValueAt(row, 0).toString());
                pNameField.setText(productTableModel.getValueAt(row, 1).toString());
                pBrandField.setText(productTableModel.getValueAt(row, 2).toString());
                pPriceField.setText(productTableModel.getValueAt(row, 3).toString());
                pDiscountField.setText(productTableModel.getValueAt(row, 4).toString());
                pStockField.setText(productTableModel.getValueAt(row, 5).toString());
                pActiveCheckbox.setSelected("ACTIVE".equalsIgnoreCase(productTableModel.getValueAt(row, 7).toString()));
            }
        });

        panel.add(topContainer, BorderLayout.NORTH);
        panel.add(new JScrollPane(productTable), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createOrderPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        String[] cols = {"Order ID", "Customer", "Total (₹)", "Discount", "Payment", "Status", "Date"};
        orderTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };
        orderTable = new JTable(orderTableModel);

        JPanel statusPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JComboBox<String> statusCombo = new JComboBox<>(new String[]{"PLACED", "CONFIRMED", "SHIPPED", "DELIVERED", "CANCELLED"});
        JButton updateStatusBtn = new JButton("Update Selected Order Status");

        updateStatusBtn.addActionListener(e -> {
            int row = orderTable.getSelectedRow();
            if (row >= 0) {
                int orderId = Integer.parseInt(orderTableModel.getValueAt(row, 0).toString());
                String newStatus = (String) statusCombo.getSelectedItem();
                try {
                    orderDAO.updateStatus(orderId, newStatus);
                    JOptionPane.showMessageDialog(this, "Order #" + orderId + " marked as " + newStatus);
                    loadOrders();
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
                }
            } else {
                JOptionPane.showMessageDialog(this, "Please select an order from the table.");
            }
        });

        statusPanel.add(new JLabel("Set Status:"));
        statusPanel.add(statusCombo);
        statusPanel.add(updateStatusBtn);

        panel.add(statusPanel, BorderLayout.NORTH);
        panel.add(new JScrollPane(orderTable), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createUserPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        String[] cols = {"User ID", "Name", "Email", "Mobile", "Role", "Status"};
        userTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };
        userTable = new JTable(userTableModel);

        panel.add(new JScrollPane(userTable), BorderLayout.CENTER);
        return panel;
    }

    private JPanel createInventoryPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        DefaultTableModel lowStockModel = new DefaultTableModel(new String[]{"Product ID", "Name", "Brand", "Current Stock", "Action Recommended"}, 0);
        JTable table = new JTable(lowStockModel);

        try {
            List<Product> lowStock = productDAO.findLowStock(15);
            for (Product p : lowStock) {
                lowStockModel.addRow(new Object[]{p.getProductId(), p.getName(), p.getBrand(), p.getStock(), "Restock Immediately!"});
            }
        } catch (Exception ignored) {}

        panel.add(new JLabel("Products below low-stock threshold (15 units):"), BorderLayout.NORTH);
        panel.add(new JScrollPane(table), BorderLayout.CENTER);
        return panel;
    }

    private void loadAllData() {
        loadCategories();
        loadProducts();
        loadOrders();
        loadUsers();
    }

    private void loadCategories() {
        try {
            pCategoryCombo.removeAllItems();
            List<Category> cats = categoryDAO.findAllActive();
            for (Category c : cats) {
                pCategoryCombo.addItem(c);
            }
        } catch (Exception ignored) {}
    }

    private void loadProducts() {
        try {
            productTableModel.setRowCount(0);
            List<Product> list = productDAO.findAll(false);
            for (Product p : list) {
                productTableModel.addRow(new Object[]{
                    p.getProductId(), p.getName(), p.getBrand(), p.getPrice(),
                    p.getDiscount(), p.getStock(), p.getCategoryName(), p.isStatus() ? "ACTIVE" : "INACTIVE"
                });
            }
        } catch (Exception ex) {
            System.err.println("Load products err: " + ex.getMessage());
        }
    }

    private void loadOrders() {
        try {
            orderTableModel.setRowCount(0);
            List<Order> list = orderDAO.findAll();
            for (Order o : list) {
                orderTableModel.addRow(new Object[]{
                    o.getOrderId(), o.getCustomerName(), o.getTotalAmount(),
                    o.getDiscount(), o.getPaymentMethod(), o.getOrderStatus(), o.getCreatedAt()
                });
            }
        } catch (Exception ignored) {}
    }

    private void loadUsers() {
        try {
            userTableModel.setRowCount(0);
            List<User> list = userDAO.findAll();
            for (User u : list) {
                userTableModel.addRow(new Object[]{
                    u.getUserId(), u.getName(), u.getEmail(), u.getMobile(), u.getRole(), u.getStatus()
                });
            }
        } catch (Exception ignored) {}
    }

    private void saveProduct() {
        try {
            String name = pNameField.getText().trim();
            String brand = pBrandField.getText().trim();
            double price = Double.parseDouble(pPriceField.getText().trim());
            double discount = Double.parseDouble(pDiscountField.getText().trim());
            int stock = Integer.parseInt(pStockField.getText().trim());
            Category cat = (Category) pCategoryCombo.getSelectedItem();
            int catId = (cat != null) ? cat.getCategoryId() : 1;

            String idStr = pIdField.getText().trim();
            int id = idStr.isEmpty() ? 0 : Integer.parseInt(idStr);

            Product p = new Product(id, catId, name, brand, "Description", price, discount, stock, "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500", pActiveCheckbox.isSelected());
            if (id > 0) {
                productDAO.update(p);
                JOptionPane.showMessageDialog(this, "Product #" + id + " updated successfully!");
            } else {
                productDAO.create(p);
                JOptionPane.showMessageDialog(this, "New product added successfully!");
            }
            clearProductForm();
            loadProducts();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error saving product: " + ex.getMessage(), "Input Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void deleteProduct() {
        String idStr = pIdField.getText().trim();
        if (idStr.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a product to delete.");
            return;
        }
        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to delete Product #" + idStr + "?", "Confirm Delete", JOptionPane.YES_NO_OPTION);
        if (confirm == JOptionPane.YES_OPTION) {
            try {
                productDAO.delete(Integer.parseInt(idStr));
                JOptionPane.showMessageDialog(this, "Product deleted.");
                clearProductForm();
                loadProducts();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void clearProductForm() {
        pIdField.setText("");
        pNameField.setText("");
        pBrandField.setText("");
        pPriceField.setText("");
        pDiscountField.setText("0");
        pStockField.setText("");
        pActiveCheckbox.setSelected(true);
        productTable.clearSelection();
    }
}
