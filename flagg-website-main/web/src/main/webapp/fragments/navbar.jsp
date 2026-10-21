<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container">
        <!-- Brand -->
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2 fs-4" href="${pageContext.request.contextPath}/">
            <span class="badge bg-primary rounded-circle p-2"><i class="bi bi-flag-fill"></i></span>
            <span class="tracking-tight text-white">Flagg<span class="text-primary">.</span></span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Search Bar -->
            <form action="${pageContext.request.contextPath}/products" method="get" class="d-flex mx-lg-4 my-2 my-lg-0 flex-grow-1" style="max-width: 520px;">
                <div class="input-group">
                    <input type="text" name="q" class="form-control bg-light border-0" placeholder="Search gadgets, apparel, books..." value="${param.q}">
                    <button class="btn btn-primary px-3" type="submit"><i class="bi bi-search"></i></button>
                </div>
            </form>

            <!-- Nav Links -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
                <li class="nav-item">
                    <a class="nav-link text-light px-2" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid me-1"></i> Catalog
                    </a>
                </li>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link text-light position-relative px-2" href="${pageContext.request.contextPath}/cart">
                                <i class="bi bi-cart3 fs-5"></i>
                                <span class="position-absolute top-1 start-100 translate-middle badge rounded-pill bg-primary">
                                    ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                                </span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-light px-2" href="${pageContext.request.contextPath}/wishlist">
                                <i class="bi bi-heart fs-5"></i>
                            </a>
                        </li>

                        <!-- User Dropdown -->
                        <li class="nav-item dropdown ms-lg-2">
                            <a class="nav-link dropdown-toggle text-light d-flex align-items-center gap-2" href="#" data-bs-toggle="dropdown">
                                <span class="badge bg-secondary rounded-circle px-2 py-1">${sessionScope.user.name.charAt(0)}</span>
                                <span>${sessionScope.user.name}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i> My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box-seam me-2"></i> My Orders</a></li>
                                <c:if test="${sessionScope.user.admin}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-shield-lock me-2"></i> Admin Portal</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-muted" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Sign Out</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item ms-lg-2">
                            <a class="btn btn-outline-light btn-sm px-3 rounded-pill" href="${pageContext.request.contextPath}/login.jsp">Sign In</a>
                        </li>
                        <li class="nav-item ms-lg-1">
                            <a class="btn btn-primary btn-sm px-3 rounded-pill" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
