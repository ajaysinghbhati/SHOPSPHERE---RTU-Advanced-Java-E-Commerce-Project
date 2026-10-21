package com.shopsphere.filter;

import com.shopsphere.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication Filter:
 * Protects customer pages (cart, checkout, profile, orders, wishlist)
 * Redirects unauthenticated users to login with return redirect parameter.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/cart", "/cart.jsp",
    "/checkout", "/checkout.jsp",
    "/orders", "/orders.jsp",
    "/order-details", "/order-details.jsp",
    "/profile", "/profile.jsp",
    "/wishlist", "/wishlist.jsp"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String requestURI = req.getRequestURI();
            String query = req.getQueryString();
            String redirectUrl = requestURI + (query != null ? "?" + query : "");
            req.getSession(true).setAttribute("redirectAfterLogin", redirectUrl);
            res.sendRedirect(req.getContextPath() + "/login.jsp?msg=Please+login+to+continue");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
