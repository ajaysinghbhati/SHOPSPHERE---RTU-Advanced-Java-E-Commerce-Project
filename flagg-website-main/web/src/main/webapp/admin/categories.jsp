<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Categories Management - Admin" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Categories</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Categories Directory</h2>
        </div>
        <button class="btn btn-primary rounded-pill btn-sm px-4" data-bs-toggle="modal" data-bs-target="#categoryModal" onclick="prepareCategoryModal()">
            <i class="bi bi-plus-lg me-1"></i> Add Category
        </button>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-1"></i> ${param.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light small text-uppercase">
                    <tr>
                        <th>ID</th>
                        <th>Category Name</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}">
                        <tr>
                            <td>#${cat.categoryId}</td>
                            <td class="fw-bold">${cat.name}</td>
                            <td class="text-muted small">${cat.description}</td>
                            <td><span class="badge ${cat.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${cat.status}</span></td>
                            <td class="text-end">
                                <div class="btn-group">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="editCategory('${cat.categoryId}', '${cat.name}', '${cat.description}', '${cat.status}')">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/category-delete" method="post" class="d-inline" onsubmit="return confirm('Delete this category?');">
                                        <input type="hidden" name="categoryId" value="${cat.categoryId}">
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

<!-- Modal -->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 border-0">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="catModalTitle">Category Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/category-save" method="post">
                <div class="modal-body">
                    <input type="hidden" name="categoryId" id="modalCatId" value="0">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Name</label>
                        <input type="text" name="name" id="modalCatName" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Description</label>
                        <textarea name="description" id="modalCatDesc" rows="3" class="form-control form-control-sm"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Status</label>
                        <select name="status" id="modalCatStatus" class="form-select form-select-sm">
                            <option value="ACTIVE">ACTIVE</option>
                            <option value="INACTIVE">INACTIVE</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function prepareCategoryModal() {
    document.getElementById('catModalTitle').innerText = 'Add Category';
    document.getElementById('modalCatId').value = '0';
    document.getElementById('modalCatName').value = '';
    document.getElementById('modalCatDesc').value = '';
    document.getElementById('modalCatStatus').value = 'ACTIVE';
}
function editCategory(id, name, desc, status) {
    document.getElementById('catModalTitle').innerText = 'Edit Category #' + id;
    document.getElementById('modalCatId').value = id;
    document.getElementById('modalCatName').value = name;
    document.getElementById('modalCatDesc').value = desc;
    document.getElementById('modalCatStatus').value = status;
    new bootstrap.Modal(document.getElementById('categoryModal')).show();
}
</script>

<%@ include file="../fragments/footer.jsp" %>
