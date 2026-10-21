<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="bg-dark text-white pt-5 pb-4 mt-auto border-top border-secondary">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="fw-bold text-white mb-3">Flagg<span class="text-primary">.</span></h5>
                <p class="text-secondary small">
                    Flagg is a premium modern e-commerce platform delivering curated electronics, designer apparel, home living, and reading collections with secure online checkout and express shipping.
                </p>
                <div class="d-flex gap-3 text-secondary fs-5">
                    <a href="#" class="text-secondary hover-white"><i class="bi bi-github"></i></a>
                    <a href="#" class="text-secondary hover-white"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="text-secondary hover-white"><i class="bi bi-twitter-x"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3 fs-7">Catalog</h6>
                <ul class="list-unstyled text-secondary small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/products?category=1" class="text-secondary text-decoration-none">Electronics</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=2" class="text-secondary text-decoration-none">Fashion Wear</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=3" class="text-secondary text-decoration-none">Home & Living</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?category=4" class="text-secondary text-decoration-none">Books & Textbooks</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3 fs-7">Customer Care</h6>
                <ul class="list-unstyled text-secondary small d-flex flex-column gap-2">
                    <li><a href="${pageContext.request.contextPath}/orders" class="text-secondary text-decoration-none">Track Order</a></li>
                    <li><a href="${pageContext.request.contextPath}/profile" class="text-secondary text-decoration-none">Account Settings</a></li>
                    <li><a href="${pageContext.request.contextPath}/wishlist" class="text-secondary text-decoration-none">My Wishlist</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" class="text-secondary text-decoration-none">View Cart</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold text-light mb-3 fs-7">Enterprise & Management</h6>
                <p class="text-secondary small mb-2">
                    Flagg is built on enterprise-grade layered architecture with multi-tier service and database layers.
                </p>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-light btn-sm rounded-pill px-3">
                        <i class="bi bi-shield-lock me-1"></i> Staff Admin Portal
                    </a>
                </div>
            </div>
        </div>

        <hr class="border-secondary my-4">

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small text-secondary">
            <div>&copy; 2026 Flagg E-Commerce Platform. All rights reserved.</div>
            <div class="d-flex gap-3 mt-2 mt-md-0">
                <span class="badge bg-success-subtle text-success border border-success-subtle">MVC N-Tier</span>
                <span class="badge bg-info-subtle text-info border border-info-subtle">JDBC & MySQL</span>
                <span class="badge bg-warning-subtle text-warning border border-warning-subtle">High Performance</span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
