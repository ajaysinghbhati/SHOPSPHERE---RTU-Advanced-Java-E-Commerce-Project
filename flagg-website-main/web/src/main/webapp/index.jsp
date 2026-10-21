<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="Flagg - Premium Online Shopping" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<!-- Hero Banner -->
<header class="hero-gradient text-white py-5 shadow-inner">
    <div class="container py-4">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">
                    <i class="bi bi-shield-check me-1"></i> 100% Genuine Products & Free Fast Delivery
                </span>
                <h1 class="display-4 fw-extrabold mb-3 tracking-tight">
                    Smart Shopping Made Simple & Fast.
                </h1>
                <p class="lead text-light mb-4">
                    Experience modern online shopping with curated collections, exclusive seasonal discounts, express delivery, and seamless checkout.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg px-4 rounded-pill fw-bold text-primary shadow-sm">
                        Explore Catalog <i class="bi bi-arrow-right ms-2"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=1" class="btn btn-outline-light btn-lg px-4 rounded-pill fw-semibold">
                        View Tech Deals <i class="bi bi-lightning-charge ms-2"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block text-center">
                <img src="https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600" alt="Featured Gadget" class="img-fluid rounded-4 shadow-lg border border-4 border-white-50" style="max-height: 340px; object-fit: cover;">
            </div>
        </div>
    </div>
</header>

<!-- Category Showcase -->
<section class="py-5 bg-white border-bottom">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold mb-1">Shop by Category</h2>
                <p class="text-muted small mb-0">Browse through our curated departments</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="text-primary fw-semibold text-decoration-none">View All <i class="bi bi-chevron-right"></i></a>
        </div>

        <div class="row g-4">
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/products?category=1" class="text-decoration-none text-dark">
                    <div class="card border-0 bg-light rounded-4 text-center p-4 hover-shadow transition">
                        <i class="bi bi-laptop fs-1 text-primary mb-2"></i>
                        <h6 class="fw-bold mb-0">Electronics</h6>
                        <span class="text-muted small">Gadgets & Tech</span>
                    </div>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/products?category=2" class="text-decoration-none text-dark">
                    <div class="card border-0 bg-light rounded-4 text-center p-4 hover-shadow transition">
                        <i class="bi bi-handbag fs-1 text-danger mb-2"></i>
                        <h6 class="fw-bold mb-0">Fashion</h6>
                        <span class="text-muted small">Apparel & Shoes</span>
                    </div>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/products?category=3" class="text-decoration-none text-dark">
                    <div class="card border-0 bg-light rounded-4 text-center p-4 hover-shadow transition">
                        <i class="bi bi-house-door fs-1 text-success mb-2"></i>
                        <h6 class="fw-bold mb-0">Home & Living</h6>
                        <span class="text-muted small">Comfort & Decor</span>
                    </div>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/products?category=4" class="text-decoration-none text-dark">
                    <div class="card border-0 bg-light rounded-4 text-center p-4 hover-shadow transition">
                        <i class="bi bi-book fs-1 text-warning mb-2"></i>
                        <h6 class="fw-bold mb-0">Books & Study</h6>
                        <span class="text-muted small">Engineering & Guides</span>
                    </div>
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Featured Deals with Tag File Demo -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold mb-1">Featured Trending Products</h2>
                <p class="text-muted small mb-0">Rendered via Reusable Tag Files (<code>&lt;tags:productCard /&gt;</code>)</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary rounded-pill btn-sm">Full Catalog</a>
        </div>

        <div class="row g-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <tags:productCard id="1" name="MacBook Air M2 13-inch" brand="Apple" price="94900.0" discount="10.0" stock="15" image="https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500" />
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <tags:productCard id="2" name="Sony WH-1000XM5 ANC Headphones" brand="Sony" price="29990.0" discount="15.0" stock="25" image="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500" />
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <tags:productCard id="6" name="Nike Air Jordan 1 Retro" brand="Nike" price="14995.0" discount="0.0" stock="8" image="https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500" />
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <tags:productCard id="9" name="Core Java: Advanced Features (Vol 2)" brand="Cay Horstmann" price="1199.0" discount="10.0" stock="50" image="https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=500" />
            </div>
        </div>
    </div>
</section>

<!-- Trust & Value Banner -->
<section class="py-5 bg-primary-subtle border-top border-bottom">
    <div class="container">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3">
                <i class="bi bi-truck fs-1 text-primary mb-2"></i>
                <h6 class="fw-bold mb-1">Free Delivery</h6>
                <p class="text-muted small mb-0">On all prepaid orders across India</p>
            </div>
            <div class="col-6 col-md-3">
                <i class="bi bi-shield-check fs-1 text-success mb-2"></i>
                <h6 class="fw-bold mb-1">Secure Payments</h6>
                <p class="text-muted small mb-0">UPI, Cards & Net Banking enabled</p>
            </div>
            <div class="col-6 col-md-3">
                <i class="bi bi-arrow-repeat fs-1 text-warning mb-2"></i>
                <h6 class="fw-bold mb-1">Easy 7-Day Returns</h6>
                <p class="text-muted small mb-0">Hassle-free exchange policy</p>
            </div>
            <div class="col-6 col-md-3">
                <i class="bi bi-headset fs-1 text-danger mb-2"></i>
                <h6 class="fw-bold mb-1">24/7 Support</h6>
                <p class="text-muted small mb-0">Dedicated customer care assistance</p>
            </div>
        </div>
    </div>
</section>

<%@ include file="fragments/footer.jsp" %>
