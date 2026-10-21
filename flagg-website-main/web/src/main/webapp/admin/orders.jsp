<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Order Fulfillment - Admin" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Orders</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Customer Orders & Fulfillment</h2>
        </div>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-1"></i> ${param.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light small text-uppercase">
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Total Amount</th>
                        <th>Payment Mode</th>
                        <th>Order Status</th>
                        <th>Date Placed</th>
                        <th class="text-end">Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td><strong>#${o.orderId}</strong></td>
                            <td>
                                <div class="fw-semibold small">${o.customerName}</div>
                                <div class="text-muted small">${o.customerEmail}</div>
                            </td>
                            <td class="fw-bold text-primary">₹${o.netPayable}</td>
                            <td><span class="badge bg-light text-dark border">${o.paymentMethod}</span></td>
                            <td>
                                <span class="badge ${o.orderStatus == 'DELIVERED' ? 'bg-success' : (o.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-primary')} px-2 py-1">
                                    ${o.orderStatus}
                                </span>
                            </td>
                            <td class="small text-muted">${o.createdAt}</td>
                            <td class="text-end">
                                <form action="${pageContext.request.contextPath}/admin/order-status" method="post" class="d-inline-flex gap-1 align-items-center">
                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                    <select name="status" class="form-select form-select-sm" style="width: 140px;">
                                        <option value="PLACED" ${o.orderStatus == 'PLACED' ? 'selected' : ''}>PLACED</option>
                                        <option value="CONFIRMED" ${o.orderStatus == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                                        <option value="SHIPPED" ${o.orderStatus == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                        <option value="DELIVERED" ${o.orderStatus == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                        <option value="CANCELLED" ${o.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                    </select>
                                    <button type="submit" class="btn btn-outline-primary btn-sm">Update</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
