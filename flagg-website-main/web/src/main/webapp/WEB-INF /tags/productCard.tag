<%@ tag description="Product Card Component" pageEncoding="UTF-8" %>
<%@ attribute name="id" required="true" type="java.lang.Integer" %>
<%@ attribute name="name" required="true" type="java.lang.String" %>
<%@ attribute name="brand" required="false" type="java.lang.String" %>
<%@ attribute name="price" required="true" type="java.lang.Double" %>
<%@ attribute name="discount" required="false" type="java.lang.Double" %>
<%@ attribute name="stock" required="true" type="java.lang.Integer" %>
<%@ attribute name="image" required="false" type="java.lang.String" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="card h-100 product-card shadow-sm border-0 position-relative">
    <c:if test="${discount > 0}">
        <span class="badge bg-danger position-absolute top-0 start-0 m-3 px-2 py-1 shadow-sm">
            ${discount}% OFF
        </span>
    </c:if>

    <div class="product-img-wrapper overflow-hidden bg-light rounded-top">
        <a href="${pageContext.request.contextPath}/product-details?id=${id}">
            <img src="${empty image ? 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500' : image}" 
                 class="card-img-top product-img" alt="${name}" 
                 style="height: 220px; object-fit: cover; transition: transform 0.3s ease;">
        </a>
    </div>

    <div class="card-body d-flex flex-column p-3">
        <div class="text-muted small text-uppercase mb-1 fw-bold tracking-wider">${brand}</div>
        <h5 class="card-title fs-6 fw-semibold mb-2" style="min-height: 40px;">
            <a href="${pageContext.request.contextPath}/product-details?id=${id}" class="text-decoration-none text-dark hover-primary">
                ${name}
            </a>
        </h5>

        <div class="d-flex align-items-baseline gap-2 mb-3 mt-auto">
            <c:choose>
                <c:when test="${discount > 0}">
                    <span class="fs-5 fw-bold text-primary">₹${price - (price * discount / 100.0)}</span>
                    <span class="text-muted text-decoration-line-through small">₹${price}</span>
                </c:when>
                <c:otherwise>
                    <span class="fs-5 fw-bold text-primary">₹${price}</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="d-flex gap-2">
            <c:choose>
                <c:when test="${stock > 0}">
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="w-100">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${id}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn btn-outline-primary btn-sm w-100 rounded-pill">
                            <i class="bi bi-cart-plus me-1"></i> Add to Cart
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-secondary btn-sm w-100 rounded-pill disabled">Out of Stock</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
