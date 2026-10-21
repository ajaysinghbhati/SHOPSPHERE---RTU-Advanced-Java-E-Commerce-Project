<%@ tag description="Star Rating Component" pageEncoding="UTF-8" %>
<%@ attribute name="rating" required="true" type="java.lang.Double" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="d-inline-flex align-items-center text-warning small">
    <c:forEach var="i" begin="1" end="5">
        <c:choose>
            <c:when test="${rating >= i}">
                <i class="bi bi-star-fill me-1"></i>
            </c:when>
            <c:when test="${rating >= (i - 0.5)}">
                <i class="bi bi-star-half me-1"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-star me-1 text-muted"></i>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <span class="text-muted ms-1 small fw-semibold">(${rating})</span>
</div>
