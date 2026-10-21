<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Orders - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fw-bold mb-0"><i class="bi bi-box-seam me-2 text-primary"></i> Order History</h2>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm rounded-pill">
            Explore More Products
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="d-flex flex-column gap-3">
                <c:forEach var="order" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                        <div class="d-flex flex-wrap justify-content-between align-items-center border-bottom pb-3 mb-3 gap-2">
                            <div>
                                <span class="fw-bold fs-5">Order #${order.orderId}</span>
                                <span class="text-muted small ms-2">Placed on ${order.createdAt}</span>
                            </div>
                            <div class="d-flex align-items-center gap-3">
                                <span class="badge ${order.orderStatus == 'DELIVERED' ? 'bg-success' : (order.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-primary')} px-3 py-2 rounded-pill">
                                    ${order.orderStatus}
                                </span>
                                <span class="fs-5 fw-bold text-dark">₹${order.netPayable}</span>
                            </div>
                        </div>

                        <!-- Item thumbnails -->
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="item" items="${order.items}">
                                        <div class="d-flex align-items-center gap-2 border rounded-3 p-2 bg-light" style="max-width: 240px;">
                                            <img src="${item.imageUrl}" class="rounded-2" style="width: 40px; height: 40px; object-fit: cover;">
                                            <div class="text-truncate small">
                                                <div class="fw-semibold text-truncate">${item.productName}</div>
                                                <div class="text-muted">Qty: ${item.quantity} × ₹${item.price}</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                                <a href="${pageContext.request.contextPath}/orders?id=${order.orderId}" class="btn btn-outline-dark btn-sm rounded-pill px-3">
                                    View Tracking & Invoice <i class="bi bi-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm text-center py-5 rounded-4 bg-white">
                <i class="bi bi-bag-x fs-1 text-muted mb-3"></i>
                <h4 class="fw-bold">No Orders Placed Yet</h4>
                <p class="text-muted mb-4">You have not ordered anything yet. Browse our store to make your first purchase!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">
                        Start Shopping
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>
