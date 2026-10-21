<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Coupon Management - Admin" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Coupons</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Promotions & Coupons Management</h2>
        </div>
        <button class="btn btn-primary rounded-pill btn-sm px-4" data-bs-toggle="modal" data-bs-target="#couponModal">
            <i class="bi bi-plus-lg me-1"></i> Create Coupon
        </button>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light small text-uppercase">
                    <tr>
                        <th>Code</th>
                        <th>Type</th>
                        <th>Value</th>
                        <th>Min Order</th>
                        <th>Max Discount</th>
                        <th>Expiry Date</th>
                        <th>Status</th>
                        <th class="text-end">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${coupons}">
                        <tr>
                            <td><strong class="text-primary">${c.code}</strong></td>
                            <td><span class="badge bg-light text-dark border">${c.discountType}</span></td>
                            <td class="fw-bold">${c.discountType == 'PERCENTAGE' ? c.discountValue += '%' : '₹' += c.discountValue}</td>
                            <td>₹${c.minimumOrder}</td>
                            <td>₹${c.maximumDiscount}</td>
                            <td class="small text-muted">${c.expiryDate}</td>
                            <td><span class="badge ${c.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${c.status}</span></td>
                            <td class="text-end">
                                <form action="${pageContext.request.contextPath}/admin/coupon-delete" method="post" class="d-inline" onsubmit="return confirm('Delete coupon?');">
                                    <input type="hidden" name="couponId" value="${c.couponId}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm"><i class="bi bi-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="couponModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 border-0">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Create Promo Coupon</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/coupon-save" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Coupon Code</label>
                        <input type="text" name="code" class="form-control form-control-sm text-uppercase" placeholder="e.g. FESTIVE25" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Discount Type</label>
                            <select name="discountType" class="form-select form-select-sm">
                                <option value="PERCENTAGE">Percentage (%)</option>
                                <option value="FLAT">Flat Amount (₹)</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Discount Value</label>
                            <input type="number" step="0.01" name="discountValue" class="form-control form-control-sm" required>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Minimum Order (₹)</label>
                            <input type="number" step="0.01" name="minimumOrder" class="form-control form-control-sm" value="500">
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Max Discount Cap (₹)</label>
                            <input type="number" step="0.01" name="maximumDiscount" class="form-control form-control-sm" value="2000">
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Expiry Date</label>
                            <input type="date" name="expiryDate" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Status</label>
                            <select name="status" class="form-select form-select-sm">
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="INACTIVE">INACTIVE</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Create</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
