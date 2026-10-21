<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Order Confirmation - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1 text-center">
    <div class="card border-0 shadow-sm p-5 rounded-4 bg-white mx-auto" style="max-width: 600px;">
        <div class="mb-4">
            <span class="badge bg-success-subtle text-success rounded-circle p-4 fs-1">
                <i class="bi bi-check-lg"></i>
            </span>
        </div>

        <h2 class="fw-bold mb-2">Order Successfully Placed!</h2>
        <p class="text-muted mb-4">
            Thank you for shopping with Flagg. Your order reference ID is <strong>#${param.orderId}</strong>.
            A confirmation receipt has been saved to your account.
        </p>

        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/orders?id=${param.orderId}" class="btn btn-primary rounded-pill px-4">
                <i class="bi bi-eye me-1"></i> View Order Details
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary rounded-pill px-4">
                Continue Shopping
            </a>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
