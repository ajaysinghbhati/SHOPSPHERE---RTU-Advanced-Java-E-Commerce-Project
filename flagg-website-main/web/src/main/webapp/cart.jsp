<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Shopping Cart - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fw-bold mb-0"><i class="bi bi-cart3 me-2 text-primary"></i> Shopping Cart</h2>
        <a href="${pageContext.request.contextPath}/products" class="text-decoration-none small text-primary fw-semibold">
            <i class="bi bi-arrow-left me-1"></i> Continue Shopping
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr class="small text-uppercase text-muted">
                                        <th style="min-width: 250px;">Product</th>
                                        <th>Price</th>
                                        <th style="width: 140px;">Quantity</th>
                                        <th>Subtotal</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.product.imageUrl}" alt="${item.product.name}" class="rounded-3" style="width: 60px; height: 60px; object-fit: cover;">
                                                    <div>
                                                        <h6 class="mb-0 fw-semibold">
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none text-dark">
                                                                ${item.product.name}
                                                            </a>
                                                        </h6>
                                                        <span class="text-muted small">${item.product.brand}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="fw-semibold">₹${item.product.discountedPrice}</td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stock}" 
                                                           class="form-control form-control-sm text-center" style="width: 65px;" onchange="this.form.submit()">
                                                </form>
                                            </td>
                                            <td class="fw-bold text-primary">₹${item.subtotal}</td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                                    <button type="submit" class="btn btn-link text-danger p-0" title="Remove item">
                                                        <i class="bi bi-trash fs-5"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Order Summary Card -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                        <h5 class="fw-bold mb-3">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Bag Subtotal</span>
                            <span class="fw-semibold">₹${cartTotal}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Estimated Shipping</span>
                            <span class="text-success fw-semibold">FREE</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 fw-bold">Total Amount</span>
                            <span class="fs-5 fw-bold text-primary">₹${cartTotal}</span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg w-100 rounded-pill fw-semibold shadow-sm">
                            Proceed to Checkout <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm text-center py-5 rounded-4 bg-white">
                <i class="bi bi-cart-x fs-1 text-muted mb-3"></i>
                <h4 class="fw-bold">Your Shopping Cart is Empty</h4>
                <p class="text-muted mb-4">Looks like you have not added any items to your cart yet.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">
                        Start Shopping Now
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>
