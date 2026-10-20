// ShopSphere / Flagg Interactive Frontend Client Engine for Vercel
(function() {
    console.log("[ShopSphere Vercel] Frontend interactivity initialized.");

    // Simple toast notification helper
    function showToast(message, type = 'success') {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'position-fixed bottom-0 end-0 p-3';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }
        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white bg-${type === 'success' ? 'success' : 'primary'} border-0 show shadow-lg mb-2`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body fw-semibold"><i class="bi bi-check-circle-fill me-2"></i> ${message}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        `;
        container.appendChild(toast);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 400);
        }, 3000);
    }

    // Intercept Add To Cart forms
    document.addEventListener('submit', function(e) {
        const form = e.target;
        const action = form.getAttribute('action') || '';
        if (action.includes('/cart')) {
            e.preventDefault();
            const actionType = form.querySelector('input[name="action"]')?.value;
            if (actionType === 'add') {
                const badge = document.querySelector('.bi-cart3 + .badge, a[href*="cart"] .badge');
                if (badge) {
                    let count = parseInt(badge.textContent.trim()) || 0;
                    badge.textContent = count + 1;
                }
                showToast('Product successfully added to cart!');
            } else if (actionType === 'remove') {
                const row = form.closest('tr');
                if (row) {
                    row.remove();
                    showToast('Item removed from cart.', 'primary');
                }
            } else {
                showToast('Cart updated!');
            }
        } else if (action.includes('/login')) {
            e.preventDefault();
            const email = form.querySelector('input[name="email"]')?.value || 'customer@shopsphere.com';
            localStorage.setItem('currentUser', email);
            showToast('Signed in successfully! Redirecting...');
            setTimeout(() => {
                if (email.includes('admin')) {
                    window.location.href = '/admin/dashboard';
                } else {
                    window.location.href = '/products';
                }
            }, 800);
        } else if (action.includes('/checkout') || form.closest('#checkoutForm') || form.id === 'checkoutForm') {
            e.preventDefault();
            showToast('Order confirmed! Generating receipt...');
            setTimeout(() => {
                window.location.href = '/order-success';
            }, 800);
        }
    });

    // Handle "Place Order" button on checkout page
    document.addEventListener('click', function(e) {
        const target = e.target.closest('button, a');
        if (!target) return;
        const text = target.textContent.trim().toLowerCase();
        if (text.includes('place order') || text.includes('confirm order')) {
            e.preventDefault();
            showToast('Order placed successfully! Redirecting...');
            setTimeout(() => {
                window.location.href = '/order-success';
            }, 800);
        }
    });

    // Normalize any legacy links
    document.querySelectorAll('a[href]').forEach(a => {
        let href = a.getAttribute('href');
        if (href.endsWith('.jsp')) {
            a.setAttribute('href', href.replace('.jsp', ''));
        }
    });
})();
