<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Order Details #${order.orderId} - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fw-bold mb-0">Order #${order.orderId} Details</h2>
        <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary btn-sm rounded-pill">
            <i class="bi bi-arrow-left me-1"></i> Back to Orders
        </a>
    </div>

    <!-- Order Timeline / Tracking Badges -->
    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
        <h6 class="text-uppercase fw-bold text-muted small mb-3">Order Status Progression</h6>
        <div class="d-flex justify-content-between align-items-center position-relative my-3">
            <div class="text-center z-1 bg-white px-2">
                <span class="badge ${order.orderStatus != 'CANCELLED' ? 'bg-success' : 'bg-secondary'} rounded-circle p-2 fs-6"><i class="bi bi-check-lg"></i></span>
                <div class="small fw-bold mt-1">Placed</div>
            </div>
            <div class="text-center z-1 bg-white px-2">
                <span class="badge ${order.orderStatus == 'CONFIRMED' || order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-secondary'} rounded-circle p-2 fs-6"><i class="bi bi-box"></i></span>
                <div class="small fw-bold mt-1">Confirmed</div>
            </div>
            <div class="text-center z-1 bg-white px-2">
                <span class="badge ${order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-secondary'} rounded-circle p-2 fs-6"><i class="bi bi-truck"></i></span>
                <div class="small fw-bold mt-1">Shipped</div>
            </div>
            <div class="text-center z-1 bg-white px-2">
                <span class="badge ${order.orderStatus == 'DELIVERED' ? 'bg-success' : 'bg-secondary'} rounded-circle p-2 fs-6"><i class="bi bi-house-check"></i></span>
                <div class="small fw-bold mt-1">Delivered</div>
            </div>
        </div>
        <c:if test="${order.orderStatus == 'CANCELLED'}">
            <div class="alert alert-danger mb-0 mt-3 small">
                <i class="bi bi-x-circle me-1"></i> This order was cancelled.
            </div>
        </c:if>
    </div>

    <div class="row g-4">
        <!-- Order Items -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <h5 class="fw-bold mb-3">Purchased Items</h5>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light small text-uppercase">
                            <tr>
                                <th>Item</th>
                                <th>Price</th>
                                <th>Qty</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img src="${item.imageUrl}" class="rounded-2" style="width: 50px; height: 50px; object-fit: cover;">
                                            <div>
                                                <div class="fw-semibold">${item.productName}</div>
                                                <div class="text-muted small">${item.productBrand}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>₹${item.price}</td>
                                    <td>${item.quantity}</td>
                                    <td class="fw-bold">₹${item.itemTotal}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Shipping & Payment Details -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4 mb-4">
                <h6 class="text-uppercase fw-bold text-muted small mb-3">Shipping Address</h6>
                <c:choose>
                    <c:when test="${not empty order.shippingAddress}">
                        <p class="mb-1 fw-semibold">${order.customerName}</p>
                        <p class="text-muted small mb-0">${order.shippingAddress.fullFormattedAddress}</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small">Standard Delivery Address</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <h6 class="text-uppercase fw-bold text-muted small mb-3">Payment Summary</h6>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Payment Mode</span>
                    <span class="badge bg-light text-dark border">${order.paymentMethod}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Payment Status</span>
                    <span class="badge bg-success-subtle text-success">${order.paymentStatus}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Subtotal</span>
                    <span>₹${order.totalAmount}</span>
                </div>
                <c:if test="${order.discount > 0}">
                    <div class="d-flex justify-content-between mb-2 small text-success">
                        <span>Discount Applied</span>
                        <span>-₹${order.discount}</span>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between fs-5 fw-bold border-top pt-2">
                    <span>Paid Amount</span>
                    <span class="text-primary">₹${order.netPayable}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
