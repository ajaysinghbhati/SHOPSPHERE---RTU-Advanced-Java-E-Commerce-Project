<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Profile - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <h2 class="fw-bold mb-4"><i class="bi bi-person-gear me-2 text-primary"></i> Account Profile</h2>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-1"></i> ${param.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-1"></i> ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Profile Info -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4 mb-4">
                <h5 class="fw-bold mb-3">Personal Information</h5>
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Full Name</label>
                        <input type="text" name="name" class="form-control" value="${user.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Email (Read Only)</label>
                        <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Mobile Number</label>
                        <input type="tel" name="mobile" class="form-control" value="${user.mobile}">
                    </div>
                    <button type="submit" class="btn btn-primary rounded-pill btn-sm px-4">Update Profile</button>
                </form>
            </div>

            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <h5 class="fw-bold mb-3">Change Password</h5>
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Current Password</label>
                        <input type="password" name="oldPassword" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">New Password</label>
                        <input type="password" name="newPassword" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="form-control form-control-sm" required>
                    </div>
                    <button type="submit" class="btn btn-dark rounded-pill btn-sm px-4">Update Password</button>
                </form>
            </div>
        </div>

        <!-- Addresses Management -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                <h5 class="fw-bold mb-3">Saved Addresses</h5>

                <c:choose>
                    <c:when test="${not empty addresses}">
                        <div class="d-flex flex-column gap-3 mb-4">
                            <c:forEach var="a" items="${addresses}">
                                <div class="p-3 border rounded-3 bg-light d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="badge bg-secondary-subtle text-dark small mb-1">${a.addressType}</span>
                                        <p class="mb-0 fw-semibold small">${a.addressLine}</p>
                                        <div class="text-muted small">${a.city}, ${a.state} - ${a.pincode}</div>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/profile" method="post">
                                        <input type="hidden" name="action" value="deleteAddress">
                                        <input type="hidden" name="addressId" value="${a.addressId}">
                                        <button type="submit" class="btn btn-link text-danger p-0" title="Delete address">
                                            <i class="bi bi-trash fs-5"></i>
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small">No saved addresses yet.</p>
                    </c:otherwise>
                </c:choose>

                <h6 class="fw-bold mb-2">Add New Address</h6>
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="addAddress">
                    <div class="mb-2">
                        <input type="text" name="addressLine" class="form-control form-control-sm" placeholder="Street Address" required>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <input type="text" name="city" class="form-control form-control-sm" placeholder="City" required>
                        </div>
                        <div class="col-6">
                            <input type="text" name="state" class="form-control form-control-sm" placeholder="State" required>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <input type="text" name="pincode" class="form-control form-control-sm" placeholder="PIN Code" required>
                        </div>
                        <div class="col-6">
                            <select name="addressType" class="form-select form-select-sm">
                                <option value="HOME">Home</option>
                                <option value="WORK">Work</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill w-100">Save Address</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
