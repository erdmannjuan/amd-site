// AMD Automation - Main JavaScript
(function() {
    'use strict';

    // ===========================================
    // CONFIGURATION
    // ===========================================
    const CONFIG = {
        hubspotPortalId: '7739025',
        hubspotFormId: 'cd38877d-8396-4826-b571-3b52287f2f84',
        abTestStorageKey: 'amd_ab_test_data',
        scrollThreshold: 50
    };

    // ===========================================
    // MOBILE MENU
    // ===========================================
    function initMobileMenu() {
        const menuBtn = document.getElementById('mobile-menu-btn');
        const mainNav = document.getElementById('main-nav');

        if (!menuBtn || !mainNav) return;

        menuBtn.addEventListener('click', function() {
            mainNav.classList.toggle('active');
            menuBtn.classList.toggle('active');
            document.body.classList.toggle('menu-open');
        });

        // Close menu when clicking outside
        document.addEventListener('click', function(e) {
            if (!mainNav.contains(e.target) && !menuBtn.contains(e.target)) {
                mainNav.classList.remove('active');
                menuBtn.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });

        // Close menu on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                mainNav.classList.remove('active');
                menuBtn.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });
    }

    // ===========================================
    // DROPDOWN MENUS
    // ===========================================
    function initDropdownMenus() {
        const dropdownItems = document.querySelectorAll('.nav-item.has-dropdown');

        dropdownItems.forEach(item => {
            const link = item.querySelector('.nav-link');
            const dropdown = item.querySelector('.dropdown-menu');

            if (!link || !dropdown) return;

            // Desktop: show on hover
            item.addEventListener('mouseenter', function() {
                if (window.innerWidth > 992) {
                    dropdown.classList.add('active');
                }
            });

            item.addEventListener('mouseleave', function() {
                if (window.innerWidth > 992) {
                    dropdown.classList.remove('active');
                }
            });

            // Mobile: toggle on click
            link.addEventListener('click', function(e) {
                if (window.innerWidth <= 992 && item.classList.contains('has-dropdown')) {
                    e.preventDefault();
                    dropdown.classList.toggle('active');
                    item.classList.toggle('dropdown-open');
                }
            });
        });
    }

    // ===========================================
    // HEADER SCROLL BEHAVIOR
    // ===========================================
    function initHeaderScroll() {
        const header = document.querySelector('.site-header');
        const topBar = document.querySelector('.header-top-bar');
        let lastScroll = 0;

        if (!header) return;

        function handleScroll() {
            const currentScroll = window.pageYOffset;

            // Add scrolled class when past threshold
            if (currentScroll > CONFIG.scrollThreshold) {
                header.classList.add('scrolled');
                if (topBar) topBar.classList.add('hidden');
            } else {
                header.classList.remove('scrolled');
                if (topBar) topBar.classList.remove('hidden');
            }

            // Hide/show header on scroll direction (optional)
            if (currentScroll > lastScroll && currentScroll > 200) {
                header.classList.add('header-hidden');
            } else {
                header.classList.remove('header-hidden');
            }

            lastScroll = currentScroll;
        }

        window.addEventListener('scroll', handleScroll, { passive: true });
    }

    // ===========================================
    // FOOTER FORM (HUBSPOT INTEGRATION)
    // ===========================================
    function initFooterForm() {
        const form = document.getElementById('footer-contact-form');
        if (!form) return;

        const formStatus = document.getElementById('footer-form-status');
        const submitBtn = form.querySelector('button[type="submit"]');

        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            // Disable submit
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';
            if (formStatus) formStatus.innerHTML = '';

            const formData = {
                fields: [
                    { name: 'firstname', value: form.querySelector('[name="firstname"]').value },
                    { name: 'lastname', value: form.querySelector('[name="lastname"]').value },
                    { name: 'email', value: form.querySelector('[name="email"]').value },
                    { name: 'company', value: form.querySelector('[name="company"]').value },
                    { name: 'phone', value: form.querySelector('[name="phone"]').value || '' },
                    { name: 'message', value: form.querySelector('[name="message"]').value || '' }
                ],
                context: {
                    pageUri: window.location.href,
                    pageName: document.title
                }
            };

            try {
                const response = await fetch(
                    `https://api.hsforms.com/submissions/v3/integration/submit/${CONFIG.hubspotPortalId}/${CONFIG.hubspotFormId}`,
                    {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(formData)
                    }
                );

                if (response.ok) {
                    if (formStatus) {
                        formStatus.innerHTML = '<p class="success">Thank you! We\'ll be in touch soon.</p>';
                    }
                    form.reset();
                    // Track conversion
                    if (typeof gtag !== 'undefined') {
                        gtag('event', 'form_submission', {
                            'event_category': 'Contact',
                            'event_label': 'Footer Form'
                        });
                    }
                } else {
                    throw new Error('Form submission failed');
                }
            } catch (error) {
                console.error('Footer form error:', error);
                if (formStatus) {
                    formStatus.innerHTML = '<p class="error">Error submitting. Please try again or call us directly.</p>';
                }
            }

            submitBtn.disabled = false;
            submitBtn.textContent = 'Get Started';
        });
    }

    // ===========================================
    // SMOOTH SCROLL
    // ===========================================
    function initSmoothScroll() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;

                const target = document.querySelector(targetId);
                if (target) {
                    e.preventDefault();
                    const headerOffset = 100;
                    const elementPosition = target.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }

    // ===========================================
    // A/B TESTING FOR RELATED CONTENT
    // ===========================================
    const ABTest = {
        // Get or create visitor ID
        getVisitorId: function() {
            let visitorId = localStorage.getItem('amd_visitor_id');
            if (!visitorId) {
                visitorId = 'v_' + Math.random().toString(36).substr(2, 9);
                localStorage.setItem('amd_visitor_id', visitorId);
            }
            return visitorId;
        },

        // Get test variant (A or B)
        getVariant: function(testName) {
            const visitorId = this.getVisitorId();
            // Use visitor ID to deterministically assign variant
            const hash = visitorId.split('').reduce((a, b) => {
                a = ((a << 5) - a) + b.charCodeAt(0);
                return a & a;
            }, 0);
            return (Math.abs(hash) % 2 === 0) ? 'A' : 'B';
        },

        // Track impression
        trackImpression: function(testName, variant, contentId) {
            const data = this.getData();
            const key = `${testName}_${variant}_${contentId}`;
            if (!data.impressions[key]) {
                data.impressions[key] = 0;
            }
            data.impressions[key]++;
            this.saveData(data);

            // Send to GA4
            if (typeof gtag !== 'undefined') {
                gtag('event', 'ab_impression', {
                    'test_name': testName,
                    'variant': variant,
                    'content_id': contentId
                });
            }
        },

        // Track click
        trackClick: function(testName, variant, contentId) {
            const data = this.getData();
            const key = `${testName}_${variant}_${contentId}`;
            if (!data.clicks[key]) {
                data.clicks[key] = 0;
            }
            data.clicks[key]++;
            this.saveData(data);

            // Send to GA4
            if (typeof gtag !== 'undefined') {
                gtag('event', 'ab_click', {
                    'test_name': testName,
                    'variant': variant,
                    'content_id': contentId
                });
            }
        },

        // Get stored data
        getData: function() {
            const stored = localStorage.getItem(CONFIG.abTestStorageKey);
            if (stored) {
                try {
                    return JSON.parse(stored);
                } catch (e) {
                    return { impressions: {}, clicks: {} };
                }
            }
            return { impressions: {}, clicks: {} };
        },

        // Save data
        saveData: function(data) {
            localStorage.setItem(CONFIG.abTestStorageKey, JSON.stringify(data));
        }
    };

    // Initialize A/B testing for related content
    function initRelatedContentAB() {
        const relatedSection = document.querySelector('.related-content');
        if (!relatedSection) return;

        const variant = ABTest.getVariant('related_content');
        const testName = 'related_content';

        // Apply variant styling if needed
        relatedSection.setAttribute('data-variant', variant);

        // Track impressions for each related item
        const relatedItems = relatedSection.querySelectorAll('.related-item');
        relatedItems.forEach((item, index) => {
            const contentId = item.getAttribute('data-content-id') || `item_${index}`;
            ABTest.trackImpression(testName, variant, contentId);

            // Track clicks
            const link = item.querySelector('a');
            if (link) {
                link.addEventListener('click', function() {
                    ABTest.trackClick(testName, variant, contentId);
                });
            }
        });

        // Variant B: Different ordering or layout
        if (variant === 'B') {
            // Shuffle items for variant B (shows different order)
            const parent = relatedItems[0]?.parentNode;
            if (parent && relatedItems.length > 1) {
                const items = Array.from(relatedItems);
                // Reverse order for variant B
                items.reverse().forEach(item => parent.appendChild(item));
            }
        }
    }

    // ===========================================
    // SIDEBAR NAVIGATION (Related Pages)
    // ===========================================
    function initSidebarNav() {
        const sidebar = document.querySelector('.content-sidebar');
        if (!sidebar) return;

        // Highlight current page in sidebar
        const currentPath = window.location.pathname;
        const sidebarLinks = sidebar.querySelectorAll('a');

        sidebarLinks.forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });

        // Make sidebar sticky on scroll
        const stickyOffset = 120;
        const sidebarInner = sidebar.querySelector('.sidebar-inner');

        if (sidebarInner && window.innerWidth > 992) {
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > stickyOffset) {
                    sidebarInner.style.position = 'sticky';
                    sidebarInner.style.top = stickyOffset + 'px';
                }
            }, { passive: true });
        }
    }

    // ===========================================
    // INITIALIZE ALL
    // ===========================================
    document.addEventListener('DOMContentLoaded', function() {
        initMobileMenu();
        initDropdownMenus();
        initHeaderScroll();
        initFooterForm();
        initSmoothScroll();
        initRelatedContentAB();
        initSidebarNav();
    });

    // Expose ABTest for external use
    window.AMDAbTest = ABTest;

})();
