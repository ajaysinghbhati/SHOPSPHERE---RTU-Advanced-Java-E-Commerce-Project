<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="Products Catalog - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-4 flex-grow-1">
    <!-- Breadcrumb & Stats -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Products</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Product Catalog</h2>
        </div>
        <div class="text-muted small mt-2 mt-md-0">
            Showing <strong>${products.size()}</strong> items
        </div>
    </div>

    <div class="row g-4">
        <!-- Sidebar Filter (N-Tier Filter Demonstration) -->
        <div class="col-lg-3">
            <div class="card border-0 shadow-sm p-3 rounded-4 sticky-top" style="top: 80px;">
                <h5 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                    <span><i class="bi bi-funnel me-1 text-primary"></i> Filters</span>
                    <a href="${pageContext.request.contextPath}/products" class="text-danger small text-decoration-none">Reset</a>
                </h5>

                <form action="${pageContext.request.contextPath}/products" method="get">
                    <!-- Search Input -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Search Keyword</label>
                        <input type="text" name="q" class="form-control form-control-sm" placeholder="e.g. Apple, Denim" value="${query}">
                    </div>

                    <!-- Categories -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Category</label>
                        <select name="category" class="form-select form-select-sm">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${selectedCategory == cat.categoryId ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Price Range -->
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Price Range (₹)</label>
                        <div class="d-flex gap-2">
                            <input type="number" name="minPrice" class="form-control form-control-sm" placeholder="Min" value="${minPrice}">
                            <input type="number" name="maxPrice" class="form-control form-control-sm" placeholder="Max" value="${maxPrice}">
                        </div>
                    </div>

                    <!-- Sort -->
                    <div class="mb-4">
                        <label class="form-label small fw-semibold text-muted">Sort By</label>
                        <select name="sort" class="form-select form-select-sm">
                            <option value="">Newest Arrivals</option>
                            <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                            <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Name: A to Z</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 rounded-pill btn-sm fw-semibold">
                        Apply Filters
                    </button>
                </form>
            </div>
        </div>

        <!-- Products Grid -->
        <div class="col-lg-9">
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row g-4">
                        <c:forEach var="p" items="${products}">
                            <div class="col-12 col-sm-6 col-md-4">
                                <tags:productCard id="${p.productId}" 
                                                  name="${p.name}" 
                                                  brand="${p.brand}" 
                                                  price="${p.price}" 
                                                  discount="${p.discount}" 
                                                  stock="${p.stock}" 
                                                  image="${p.imageUrl}" />
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm text-center py-5 rounded-4">
                        <i class="bi bi-search fs-1 text-muted mb-3"></i>
                        <h4 class="fw-bold">No Products Found</h4>
                        <p class="text-muted">Try clearing your filters or search keywords.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary rounded-pill btn-sm px-4">
                                Browse All Products
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
