<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Admin Dashboard - Flagg" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <span class="badge bg-danger-subtle text-danger fw-bold px-3 py-1 rounded-pill mb-1">
                <i class="bi bi-shield-lock-fill me-1"></i> Admin Console
            </span>
            <h2 class="fw-bold mb-0">Operations Dashboard</h2>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-primary btn-sm rounded-pill">Manage Products</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-dark btn-sm rounded-pill">Manage Orders</a>
        </div>
    </div>

    <!-- Analytics Stat Cards -->
    <div class="row g-4 mb-5">
        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Total Sales Revenue</div>
                        <h3 class="fw-bold mb-0 mt-1 text-primary">₹${totalRevenue}</h3>
                    </div>
                    <span class="badge bg-primary-subtle text-primary p-3 rounded-circle fs-4">
                        <i class="bi bi-currency-rupee"></i>
                    </span>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Total Orders</div>
                        <h3 class="fw-bold mb-0 mt-1">${totalOrders}</h3>
                    </div>
                    <span class="badge bg-success-subtle text-success p-3 rounded-circle fs-4">
                        <i class="bi bi-receipt"></i>
                    </span>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Active Products</div>
                        <h3 class="fw-bold mb-0 mt-1">${productCount}</h3>
                    </div>
                    <span class="badge bg-info-subtle text-info p-3 rounded-circle fs-4">
                        <i class="bi bi-box-seam"></i>
                    </span>
                </div>
            </div>
        </div>

        <div class="col-sm-6 col-xl-3">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <div class="text-muted small fw-semibold text-uppercase">Low-Stock Alert</div>
                        <h3 class="fw-bold mb-0 mt-1 text-danger">${lowStockCount}</h3>
                    </div>
                    <span class="badge bg-danger-subtle text-danger p-3 rounded-circle fs-4">
                        <i class="bi bi-exclamation-octagon"></i>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Navigation Cards & Low Stock Table -->
    <div class="row g-4">
        <!-- Low-stock inventory alert -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0"><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Low-Stock Inventory Monitor</h5>
                    <span class="badge bg-danger">Threshold: &le; 15 units</span>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light small">
                            <tr>
                                <th>Product</th>
                                <th>Brand</th>
                                <th>Category</th>
                                <th>Stock</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${lowStockProducts}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img src="${p.imageUrl}" class="rounded-2" style="width: 35px; height: 35px; object-fit: cover;">
                                            <span class="fw-semibold small">${p.name}</span>
                                        </div>
                                    </td>
                                    <td class="small">${p.brand}</td>
                                    <td class="small">${p.categoryName}</td>
                                    <td>
                                        <span class="badge bg-danger-subtle text-danger fw-bold">${p.stock} left</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-primary btn-sm py-0">Restock</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Management Navigation Hub -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <h5 class="fw-bold mb-3">Administration Modules</h5>
                <div class="list-group list-group-flush gap-2">
                    <a href="${pageContext.request.contextPath}/admin/products" class="list-group-item list-group-item-action border rounded-3 d-flex align-items-center justify-content-between">
                        <div><i class="bi bi-laptop me-2 text-primary"></i> Product Catalog CRUD</div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action border rounded-3 d-flex align-items-center justify-content-between">
                        <div><i class="bi bi-tag me-2 text-success"></i> Categories Management</div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action border rounded-3 d-flex align-items-center justify-content-between">
                        <div><i class="bi bi-truck me-2 text-warning"></i> Order Fulfillment & Status</div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action border rounded-3 d-flex align-items-center justify-content-between">
                        <div><i class="bi bi-people me-2 text-info"></i> Customer Management</div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/coupons" class="list-group-item list-group-item-action border rounded-3 d-flex align-items-center justify-content-between">
                        <div><i class="bi bi-ticket-perforated me-2 text-danger"></i> Coupons & Discounts</div>
                        <i class="bi bi-chevron-right text-muted"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
