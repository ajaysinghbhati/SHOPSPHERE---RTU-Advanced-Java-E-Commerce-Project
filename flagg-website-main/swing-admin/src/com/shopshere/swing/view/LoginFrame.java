package com.shopsphere.swing.view;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.DBUtil;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * RTU Syllabus Swing Demonstration:
 * Login Frame utilizing JFrame, JPanel, JLabel, JTextField, JPasswordField, JButton,
 * Pluggable Look and Feel, and JOptionPane.
 */
public class LoginFrame extends JFrame {
    private JTextField emailField;
    private JPasswordField passwordField;
    private JButton loginButton;
    private JButton exitButton;

    public LoginFrame() {
        setTitle("Flagg Admin Portal - Desktop Application");
        setSize(420, 260);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);

        initComponents();
    }

    private void initComponents() {
        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 25, 20, 25));

        // Header Banner
        JLabel titleLabel = new JLabel("Flagg Desktop Admin", SwingConstants.CENTER);
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 18));
        titleLabel.setForeground(new Color(24, 76, 120));
        mainPanel.add(titleLabel, BorderLayout.NORTH);

        // Form fields
        JPanel formPanel = new JPanel(new GridLayout(2, 2, 10, 15));
        JLabel emailLabel = new JLabel("Admin Email:");
        emailLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        emailField = new JTextField("admin@shopsphere.com");

        JLabel passwordLabel = new JLabel("Password:");
        passwordLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        passwordField = new JPasswordField("admin123");

        formPanel.add(emailLabel);
        formPanel.add(emailField);
        formPanel.add(passwordLabel);
        formPanel.add(passwordField);
        mainPanel.add(formPanel, BorderLayout.CENTER);

        // Action Buttons
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        exitButton = new JButton("Exit");
        exitButton.addActionListener(e -> System.exit(0));

        loginButton = new JButton("Login");
        loginButton.setBackground(new Color(30, 144, 255));
        loginButton.setForeground(Color.WHITE);
        loginButton.setFocusPainted(false);
        loginButton.setFont(new Font("Segoe UI", Font.BOLD, 12));

        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                performLogin();
            }
        });

        buttonPanel.add(exitButton);
        buttonPanel.add(loginButton);
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        setContentPane(mainPanel);
    }

    private void performLogin() {
        String email = emailField.getText().trim();
        String pass = new String(passwordField.getPassword());

        if (email.isEmpty() || pass.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter both email and password.", "Validation Error", JOptionPane.WARNING_MESSAGE);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            String hashed = DBUtil.hashPassword(pass);
            User user = dao.authenticate(email, hashed);

            if (user != null && user.isAdmin()) {
                JOptionPane.showMessageDialog(this, "Welcome " + user.getName() + "!", "Login Success", JOptionPane.INFORMATION_MESSAGE);
                dispose();
                SwingUtilities.invokeLater(() -> new AdminDashboard(user).setVisible(true));
            } else {
                JOptionPane.showMessageDialog(this, "Invalid credentials or user is not an administrator.", "Access Denied", JOptionPane.ERROR_MESSAGE);
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Database Connection Error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) {
        // Apply Pluggable Look and Feel
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}

        SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true));
    }
}
