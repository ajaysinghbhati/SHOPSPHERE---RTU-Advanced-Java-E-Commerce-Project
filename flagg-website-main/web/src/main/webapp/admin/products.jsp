<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Product Management - Admin" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Products</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Products Catalog Management</h2>
        </div>
        <button class="btn btn-primary rounded-pill btn-sm px-4" data-bs-toggle="modal" data-bs-target="#productModal" onclick="prepareCreateModal()">
            <i class="bi bi-plus-lg me-1"></i> Add New Product
        </button>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-1"></i> ${param.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Products Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light small text-uppercase">
                    <tr>
                        <th>ID</th>
                        <th>Product</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>#${p.productId}</td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <img src="${p.imageUrl}" class="rounded-2" style="width: 40px; height: 40px; object-fit: cover;">
                                    <div>
                                        <div class="fw-semibold small">${p.name}</div>
                                        <div class="text-muted small">${p.brand}</div>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge bg-light text-dark border">${p.categoryName}</span></td>
                            <td class="fw-bold">₹${p.price}</td>
                            <td>${p.discount}%</td>
                            <td>
                                <span class="badge ${p.stock <= 15 ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'}">
                                    ${p.stock} units
                                </span>
                            </td>
                            <td>
                                <span class="badge ${p.status ? 'bg-success' : 'bg-secondary'}">${p.status ? 'ACTIVE' : 'INACTIVE'}</span>
                            </td>
                            <td class="text-end">
                                <div class="btn-group">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="editProduct('${p.productId}', '${p.categoryId}', '${p.name}', '${p.brand}', '${p.price}', '${p.discount}', '${p.stock}', '${p.imageUrl}', '${p.status}', '${p.description}')">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/product-delete" method="post" class="d-inline" onsubmit="return confirm('Delete this product?');">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm"><i class="bi bi-trash"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Product Add / Edit Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content rounded-4 border-0">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="modalTitle">Product Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/product-save" method="post">
                <div class="modal-body">
                    <input type="hidden" name="productId" id="modalProductId" value="0">

                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Product Name</label>
                            <input type="text" name="name" id="modalName" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Brand</label>
                            <input type="text" name="brand" id="modalBrand" class="form-control form-control-sm" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Category</label>
                            <select name="categoryId" id="modalCategoryId" class="form-select form-select-sm" required>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}">${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Status</label>
                            <select name="status" id="modalStatus" class="form-select form-select-sm">
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="INACTIVE">INACTIVE</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" id="modalPrice" class="form-control form-control-sm" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Discount (%)</label>
                            <input type="number" step="0.01" name="discount" id="modalDiscount" class="form-control form-control-sm" value="0">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Stock Quantity</label>
                            <input type="number" name="stock" id="modalStock" class="form-control form-control-sm" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold">Image URL</label>
                            <input type="url" name="imageUrl" id="modalImageUrl" class="form-control form-control-sm" placeholder="https://..." required>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold">Product Description</label>
                            <textarea name="description" id="modalDescription" rows="3" class="form-control form-control-sm"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Save Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function prepareCreateModal() {
    document.getElementById('modalTitle').innerText = 'Add New Product';
    document.getElementById('modalProductId').value = '0';
    document.getElementById('modalName').value = '';
    document.getElementById('modalBrand').value = '';
    document.getElementById('modalPrice').value = '';
    document.getElementById('modalDiscount').value = '0';
    document.getElementById('modalStock').value = '';
    document.getElementById('modalImageUrl').value = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500';
    document.getElementById('modalDescription').value = '';
}

function editProduct(id, catId, name, brand, price, discount, stock, img, status, desc) {
    document.getElementById('modalTitle').innerText = 'Edit Product #' + id;
    document.getElementById('modalProductId').value = id;
    document.getElementById('modalCategoryId').value = catId;
    document.getElementById('modalName').value = name;
    document.getElementById('modalBrand').value = brand;
    document.getElementById('modalPrice').value = price;
    document.getElementById('modalDiscount').value = discount;
    document.getElementById('modalStock').value = stock;
    document.getElementById('modalImageUrl').value = img;
    document.getElementById('modalStatus').value = status ? 'ACTIVE' : 'INACTIVE';
    document.getElementById('modalDescription').value = desc;
    new bootstrap.Modal(document.getElementById('productModal')).show();
}
</script>

<%@ include file="../fragments/footer.jsp" %>
