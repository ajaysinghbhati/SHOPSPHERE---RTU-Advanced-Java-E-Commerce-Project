<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="My Wishlist - Flagg" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container py-5 flex-grow-1">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fw-bold mb-0"><i class="bi bi-heart me-2 text-danger"></i> My Wishlist</h2>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm rounded-pill">
            Add More Items
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty wishlist}">
            <div class="row g-4">
                <c:forEach var="item" items="${wishlist}">
                    <div class="col-12 col-sm-6 col-lg-3 position-relative">
                        <tags:productCard id="${item.product.productId}" 
                                          name="${item.product.name}" 
                                          brand="${item.product.brand}" 
                                          price="${item.product.price}" 
                                          discount="${item.product.discount}" 
                                          stock="${item.product.stock}" 
                                          image="${item.product.imageUrl}" />

                        <!-- Remove button overlay -->
                        <form action="${pageContext.request.contextPath}/wishlist" method="post" class="position-absolute" style="top: 12px; right: 24px; z-index: 10;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="${item.product.productId}">
                            <button type="submit" class="btn btn-light btn-sm rounded-circle shadow-sm text-danger" title="Remove from wishlist">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm text-center py-5 rounded-4 bg-white">
                <i class="bi bi-heartbreak fs-1 text-muted mb-3"></i>
                <h4 class="fw-bold">Your Wishlist is Empty</h4>
                <p class="text-muted mb-4">Save favorite products here to buy them later!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">
                        Discover Products
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>
