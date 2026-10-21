<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Admin Access - Flagg" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 440px;">
        <div class="text-center mb-4">
            <span class="badge bg-danger-subtle text-danger p-3 rounded-circle fs-3 mb-2">
                <i class="bi bi-shield-lock-fill"></i>
            </span>
            <h3 class="fw-bold mb-1">Admin Portal</h3>
            <p class="text-muted small">Restricted Administrator Authentication</p>
        </div>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="bi bi-exclamation-circle me-1"></i> ${param.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Admin Email</label>
                <input type="email" name="email" class="form-control" value="admin@shopsphere.com" required>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-semibold text-muted">Admin Password</label>
                <input type="password" name="password" class="form-control" value="admin123" required>
            </div>

            <button type="submit" class="btn btn-danger w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3">
                Access Admin Dashboard
            </button>
        </form>

        <div class="text-center small text-muted">
            <a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none">Customer Login</a>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
