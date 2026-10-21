<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Create an Account - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1 d-flex align-items-center justify-content-center">
    <div class="card border-0 shadow-lg rounded-4 p-4 p-md-5 bg-white w-100" style="max-width: 500px;">
        <div class="text-center mb-4">
            <span class="badge bg-primary-subtle text-primary p-3 rounded-circle fs-3 mb-2">
                <i class="bi bi-person-plus-fill"></i>
            </span>
            <h3 class="fw-bold mb-1">Create Account</h3>
            <p class="text-muted small">Join Flagg to order products with exclusive offers</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="bi bi-exclamation-circle me-1"></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Full Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. John Doe" required>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="name@domain.com" required>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-semibold text-muted">Mobile Number</label>
                <input type="tel" name="mobile" class="form-control" placeholder="e.g. 9876543210">
            </div>

            <div class="row g-2 mb-4">
                <div class="col-md-6">
                    <label class="form-label small fw-semibold text-muted">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-semibold text-muted">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold shadow-sm mb-3">
                Complete Registration
            </button>
        </form>

        <div class="text-center small text-muted">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary fw-semibold text-decoration-none">Sign In here</a>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
