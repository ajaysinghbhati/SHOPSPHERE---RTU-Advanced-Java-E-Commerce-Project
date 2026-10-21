<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="${product.name} - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Products</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <div class="row g-5">
        <!-- Product Image Gallery -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3 text-center">
                <img src="${empty product.imageUrl ? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600' : product.imageUrl}" 
                     alt="${product.name}" class="img-fluid rounded-3" style="max-height: 440px; object-fit: contain;">
            </div>
        </div>

        <!-- Product Purchase Information -->
        <div class="col-lg-6">
            <div class="d-flex align-items-center gap-2 mb-2">
                <span class="badge bg-primary-subtle text-primary fw-bold px-3 py-1 rounded-pill">${product.categoryName}</span>
                <span class="text-muted fw-semibold">${product.brand}</span>
            </div>

            <h1 class="fw-bold mb-3">${product.name}</h1>

            <div class="d-flex align-items-center gap-3 mb-4">
                <tags:rating rating="${avgRating}" />
                <span class="text-muted small">(${reviews.size()} Verified Reviews)</span>
            </div>

            <div class="p-3 bg-white rounded-3 shadow-sm border mb-4">
                <div class="d-flex align-items-baseline gap-3 mb-2">
                    <span class="display-6 fw-bold text-primary">₹${product.discountedPrice}</span>
                    <c:if test="${product.discount > 0}">
                        <span class="fs-4 text-muted text-decoration-line-through">₹${product.price}</span>
                        <span class="badge bg-danger px-2 py-1">${product.discount}% OFF</span>
                    </c:if>
                </div>
                <div class="small ${product.stock > 0 ? 'text-success' : 'text-danger'} fw-semibold">
                    <i class="bi ${product.stock > 0 ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                    ${product.stock > 0 ? 'In Stock (' += product.stock += ' available)' : 'Currently Out of Stock'}
                </div>
            </div>

            <p class="text-secondary leading-relaxed mb-4">
                ${product.description}
            </p>

            <!-- Actions -->
            <c:if test="${product.stock > 0}">
                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex flex-wrap gap-3 mb-4">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.productId}">

                    <div style="width: 100px;">
                        <input type="number" name="quantity" class="form-control form-control-lg text-center" value="1" min="1" max="${product.stock}">
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg px-4 flex-grow-1 rounded-pill shadow-sm">
                        <i class="bi bi-cart-plus me-2"></i> Add to Cart
                    </button>
                </form>
            </c:if>

            <form action="${pageContext.request.contextPath}/wishlist" method="post">
                <input type="hidden" name="action" value="${inWishlist ? 'remove' : 'add'}">
                <input type="hidden" name="productId" value="${product.productId}">
                <button type="submit" class="btn ${inWishlist ? 'btn-danger' : 'btn-outline-secondary'} rounded-pill">
                    <i class="bi ${inWishlist ? 'bi-heart-fill' : 'bi-heart'} me-1"></i>
                    ${inWishlist ? 'Saved in Wishlist' : 'Add to Wishlist'}
                </button>
            </form>
        </div>
    </div>

    <!-- Customer Reviews Section -->
    <div class="row mt-5 pt-4 border-top">
        <div class="col-lg-7">
            <h3 class="fw-bold mb-4">Customer Reviews & Ratings</h3>

            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="rev" items="${reviews}">
                            <div class="card border-0 shadow-sm p-3 rounded-3 bg-white">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold">${rev.userName}</span>
                                    <tags:rating rating="${rev.rating + 0.0}" />
                                </div>
                                <p class="text-secondary mb-0 small">${rev.reviewText}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">No reviews yet. Be the first to review this product!</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Write Review Form -->
        <div class="col-lg-5 mt-4 mt-lg-0">
            <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
                <h5 class="fw-bold mb-3">Leave a Review</h5>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <form action="${pageContext.request.contextPath}/review" method="post">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-muted">Rating (1 to 5 Stars)</label>
                                <select name="rating" class="form-select form-select-sm" required>
                                    <option value="5">⭐⭐⭐⭐⭐ 5 - Excellent</option>
                                    <option value="4">⭐⭐⭐⭐ 4 - Very Good</option>
                                    <option value="3">⭐⭐⭐ 3 - Average</option>
                                    <option value="2">⭐⭐ 2 - Poor</option>
                                    <option value="1">⭐ 1 - Terrible</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-muted">Your Experience / Feedback</label>
                                <textarea name="reviewText" rows="3" class="form-control form-control-sm" placeholder="Write your honest review..." required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 rounded-pill btn-sm fw-semibold">
                                Submit Review
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <p class="text-muted small mb-3">You must be logged in to leave a product review.</p>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary btn-sm rounded-pill px-4">
                                Sign In to Review
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
