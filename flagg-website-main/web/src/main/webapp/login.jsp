<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 440px;">
        <div class="text-center mb-4">
            <span class="badge bg-primary-subtle text-primary p-3 rounded-circle fs-3 mb-2">
                <i class="bi bi-person-fill-lock"></i>
            </span>
            <h3 class="fw-bold mb-1">Welcome Back</h3>
            <p class="text-muted small">Sign in to your Flagg account</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="bi bi-exclamation-circle me-1"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success py-2 small mb-3">
                <i class="bi bi-check-circle me-1"></i> ${param.msg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                    <input type="email" name="email" class="form-control border-start-0" placeholder="name@example.com" 
                           value="${not empty email ? email : (not empty cookie.savedEmail.value ? cookie.savedEmail.value : 'customer@shopsphere.com')}" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-muted"></i></span>
                    <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" value="user123" required>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-4 small">
                <div class="form-check">
                    <input type="checkbox" name="remember" class="form-check-input" id="rememberMe" checked>
                    <label class="form-check-label text-muted" for="rememberMe">Remember email</label>
                </div>
                <a href="#" class="text-primary text-decoration-none">Forgot password?</a>
            </div>

            <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3">
                Sign In
            </button>
        </form>

        <div class="p-3 bg-light rounded-3 small text-muted mb-3 border">
            <div class="fw-bold text-dark mb-1"><i class="bi bi-info-circle me-1"></i> Demo Credentials:</div>
            <div><strong>Customer:</strong> customer@shopsphere.com / <code>user123</code></div>
            <div><strong>Admin:</strong> admin@shopsphere.com / <code>admin123</code></div>
        </div>

        <div class="text-center small text-muted">
            Don't have an account? 
            <a href="${pageContext.request.contextPath}/register.jsp" class="text-primary fw-semibold text-decoration-none">Register here</a>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
