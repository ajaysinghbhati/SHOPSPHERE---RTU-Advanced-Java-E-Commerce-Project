<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="User Directory - Admin" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container-fluid py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Customers</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-0">Registered Customer Accounts</h2>
        </div>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white p-3">
        <div class="table-responsive">
            <table class="table align-middle table-hover">
                <thead class="table-light small text-uppercase">
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Mobile</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>#${u.userId}</td>
                            <td class="fw-semibold">${u.name}</td>
                            <td>${u.email}</td>
                            <td>${u.mobile}</td>
                            <td><span class="badge ${u.admin ? 'bg-danger' : 'bg-secondary'}">${u.role}</span></td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}">${u.status}</span>
                            </td>
                            <td class="text-end">
                                <form action="${pageContext.request.contextPath}/admin/user-status" method="post" class="d-inline">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'BLOCKED' : 'ACTIVE'}">
                                    <button type="submit" class="btn btn-outline-${u.status == 'ACTIVE' ? 'warning' : 'success'} btn-sm">
                                        ${u.status == 'ACTIVE' ? 'Block' : 'Activate'}
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

<%@ include file="../fragments/footer.jsp" %>
