<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Secure Checkout - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <h2 class="fw-bold mb-4"><i class="bi bi-shield-check me-2 text-primary"></i> Secure Checkout</h2>

    <c:if test="${not empty couponMessage}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="bi bi-info-circle me-2"></i> ${couponMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>

    <div class="row g-5">
        <!-- Main Form (Address & Payment) -->
        <div class="col-lg-7">
            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                <input type="hidden" name="couponCode" value="${appliedCoupon}">

                <!-- 1. Delivery Address Selection -->
                <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">1. Select Shipping Address</h5>
                        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" data-bs-toggle="collapse" data-bs-target="#newAddressCollapse">
                            + Add New Address
                        </button>
                    </div>

                    <!-- Add Address Collapse Form -->
                    <div class="collapse mb-3" id="newAddressCollapse">
                        <div class="p-3 bg-light rounded-3 border">
                            <h6 class="fw-bold mb-2">New Address Details</h6>
                            <div class="row g-2">
                                <div class="col-12">
                                    <input type="text" name="addressLine" form="newAddressForm" class="form-control form-control-sm" placeholder="Street Address, House No." required>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" name="city" form="newAddressForm" class="form-control form-control-sm" placeholder="City" required>
                                </div>
                                <div class="col-md-4">
                                    <input type="text" name="state" form="newAddressForm" class="form-control form-control-sm" placeholder="State" required>
                                </div>
                                <div class="col-md-3">
                                    <input type="text" name="pincode" form="newAddressForm" class="form-control form-control-sm" placeholder="PIN" required>
                                </div>
                                <div class="col-12 mt-2">
                                    <button type="submit" form="newAddressForm" class="btn btn-primary btn-sm px-3">Save & Use Address</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Existing Address Radio List -->
                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="d-flex flex-column gap-2">
                                <c:forEach var="addr" items="${addresses}" varStatus="loop">
                                    <div class="form-check p-3 border rounded-3 d-flex align-items-center gap-2">
                                        <input class="form-check-input ms-0 me-2" type="radio" name="addressId" id="addr_${addr.addressId}" value="${addr.addressId}" ${loop.first ? 'checked' : ''} required>
                                        <label class="form-check-label w-100" for="addr_${addr.addressId}">
                                            <span class="badge bg-secondary-subtle text-dark small me-2">${addr.addressType}</span>
                                            <strong>${addr.addressLine}</strong>, ${addr.city}, ${addr.state} - ${addr.pincode}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning small mb-0">
                                No shipping address found. Please click "+ Add New Address" above to proceed.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 2. Mock Payment Selection -->
                <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                    <h5 class="fw-bold mb-3">2. Select Payment Method</h5>
                    <div class="d-flex flex-column gap-3">
                        <div class="form-check p-3 border rounded-3">
                            <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payUPI" value="UPI" checked>
                            <label class="form-check-label fw-semibold" for="payUPI">
                                <i class="bi bi-qr-code-scan me-2 text-primary"></i> Instant UPI / QR Code (Google Pay, PhonePe, Paytm)
                            </label>
                        </div>
                        <div class="form-check p-3 border rounded-3">
                            <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCard" value="CARD">
                            <label class="form-check-label fw-semibold" for="payCard">
                                <i class="bi bi-credit-card-2-front me-2 text-success"></i> Credit / Debit Card (Visa, MasterCard, RuPay)
                            </label>
                        </div>
                        <div class="form-check p-3 border rounded-3">
                            <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="payCOD" value="COD">
                            <label class="form-check-label fw-semibold" for="payCOD">
                                <i class="bi bi-cash-stack me-2 text-warning"></i> Cash on Delivery (COD)
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Complete Order Button -->
                <button type="submit" class="btn btn-success btn-lg w-100 rounded-pill fw-bold shadow">
                    Pay ₹${total} & Place Order
                </button>
            </form>

            <!-- Separate helper form for address saving -->
            <form action="${pageContext.request.contextPath}/checkout" method="post" id="newAddressForm" style="display: none;">
                <input type="hidden" name="action" value="addAddress">
                <input type="hidden" name="addressType" value="HOME">
            </form>
        </div>

        <!-- Sidebar Order & Coupon Breakdown -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                <h5 class="fw-bold mb-3">Order Summary (${cartItems.size()} items)</h5>

                <div class="d-flex flex-column gap-3 mb-3" style="max-height: 250px; overflow-y: auto;">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <img src="${item.product.imageUrl}" class="rounded-2" style="width: 45px; height: 45px; object-fit: cover;">
                                <div>
                                    <div class="small fw-semibold text-truncate" style="max-width: 170px;">${item.product.name}</div>
                                    <div class="text-muted small">Qty: ${item.quantity}</div>
                                </div>
                            </div>
                            <span class="small fw-bold">₹${item.subtotal}</span>
                        </div>
                    </c:forEach>
                </div>

                <!-- Coupon Form -->
                <form action="${pageContext.request.contextPath}/checkout" method="get" class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Promo / Coupon Code</label>
                    <div class="input-group">
                        <input type="text" name="coupon" class="form-control form-control-sm text-uppercase" placeholder="e.g. WELCOME10, RTU500" value="${appliedCoupon}">
                        <button class="btn btn-dark btn-sm px-3" type="submit">Apply</button>
                    </div>
                    <div class="form-text small">Try active coupons: <code>WELCOME10</code> or <code>RTU500</code></div>
                </form>

                <hr>

                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Subtotal</span>
                    <span class="fw-semibold">₹${subtotal}</span>
                </div>
                <c:if test="${discount > 0}">
                    <div class="d-flex justify-content-between mb-2 small text-success">
                        <span>Coupon Discount (${appliedCoupon})</span>
                        <span class="fw-semibold">-₹${discount}</span>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between mb-3 small">
                    <span class="text-muted">Delivery Charges</span>
                    <span class="text-success fw-semibold">FREE</span>
                </div>

                <div class="d-flex justify-content-between fs-5 fw-bold border-top pt-3">
                    <span>Net Payable</span>
                    <span class="text-primary">₹${total}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
