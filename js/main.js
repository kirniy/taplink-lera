// CHOIS - Main JavaScript
// ========================================================================

(function() {
    'use strict';

    // Wait for DOM to be ready
    document.addEventListener('DOMContentLoaded', function() {
        initCatalogButton();
        initSmoothScroll();
        initRevealOnScroll();
        initParallaxEffect();
        initProductHover();
        initDeliveryAccordion();
        initAnimations();
        initFooterEmails();
    });

    // Catalog button scroll to products
    function initCatalogButton() {
        const catalogButton = document.querySelector('.catalog-button');
        if (catalogButton) {
            catalogButton.addEventListener('click', function() {
                const productsSection = document.querySelector('.products-section');
                if (productsSection) {
                    productsSection.scrollIntoView({ 
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        }
    }

    // Smooth Scroll for anchor links
    function initSmoothScroll() {
        const links = document.querySelectorAll('a[href^="#"]');
        
        links.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (!targetElement) return;
                
                const headerOffset = 80;
                const elementPosition = targetElement.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            });
        });
    }

    // Reveal elements on scroll
    function initRevealOnScroll() {
        const reveals = document.querySelectorAll('.reveal');
        
        if (reveals.length === 0) {
            // Add reveal class to elements
            const elementsToReveal = [
                '.product-card',
                '.about-text',
                '.gallery-item',
                '.feature-item',
                '.delivery-item'
            ];
            
            elementsToReveal.forEach(selector => {
                document.querySelectorAll(selector).forEach(el => {
                    el.classList.add('reveal');
                });
            });
        }
        
        function revealOnScroll() {
            const reveals = document.querySelectorAll('.reveal');
            
            reveals.forEach(element => {
                const windowHeight = window.innerHeight;
                const elementTop = element.getBoundingClientRect().top;
                const elementVisible = 150;
                
                if (elementTop < windowHeight - elementVisible) {
                    element.classList.add('active');
                }
            });
        }
        
        window.addEventListener('scroll', revealOnScroll);
        revealOnScroll(); // Check on init
    }

    // Parallax effect for hero and gallery images
    function initParallaxEffect() {
        const heroBg = document.querySelector('.hero-bg-image');
        
        function handleParallax() {
            const scrolled = window.pageYOffset;
            
            if (heroBg && scrolled < window.innerHeight) {
                const speed = 0.5;
                const yPos = scrolled * speed;
                heroBg.style.transform = `translateY(${yPos}px)`;
            }
        }
        
        // Only on desktop
        if (window.innerWidth > 768) {
            window.addEventListener('scroll', handleParallax);
        }
    }

    // Lazy loading for images
    function initLazyLoading() {
        const images = document.querySelectorAll('img[data-src]');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver(function(entries, observer) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.classList.add('loaded');
                        imageObserver.unobserve(img);
                    }
                });
            });
            
            images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback for older browsers
            images.forEach(img => {
                img.src = img.dataset.src;
                img.classList.add('loaded');
            });
        }
    }

    // Product card hover effects
    function initProductHover() {
        const productCards = document.querySelectorAll('.product-card');
        
        productCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-5px)';
                this.style.boxShadow = '0 10px 30px rgba(121, 18, 39, 0.2)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        });
    }

    // Delivery accordion functionality
    function initDeliveryAccordion() {
        const deliveryItems = document.querySelectorAll('.delivery-item');
        
        deliveryItems.forEach(item => {
            item.addEventListener('click', function() {
                // Toggle active class
                this.classList.toggle('active');
                
                // Rotate arrow
                const arrow = this.querySelector('.delivery-arrow');
                if (arrow) {
                    if (this.classList.contains('active')) {
                        arrow.style.transform = 'rotate(45deg)';
                    } else {
                        arrow.style.transform = 'rotate(315deg)';
                    }
                }
                
                // Here you could add content expansion if needed
            });
        });
    }

    // Footer email click to copy
    function initFooterEmails() {
        const emailElements = document.querySelectorAll('.footer-contacts p');
        emailElements.forEach(element => {
            element.style.cursor = 'pointer';
            element.addEventListener('click', function() {
                const text = this.textContent;
                const email = text.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/);
                if (email) {
                    navigator.clipboard.writeText(email[0]).then(() => {
                        const originalText = this.textContent;
                        this.textContent = 'Скопировано!';
                        setTimeout(() => {
                            this.textContent = originalText;
                        }, 2000);
                    });
                }
            });
        });
    }

    // Initialize animations
    function initAnimations() {
        // Stagger animations for product cards
        const productCards = document.querySelectorAll('.product-card');
        productCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('stagger-item');
        });
        
        // Wave animation for decorative elements
        const waves = document.querySelectorAll('.wave-icon');
        waves.forEach(wave => {
            wave.style.transition = 'transform 0.3s ease';
            wave.addEventListener('mouseenter', function() {
                this.style.transform = this.classList.contains('wave-left') 
                    ? 'rotate(180deg) scaleY(-1) translateY(-5px)' 
                    : 'translateY(-5px)';
            });
            
            wave.addEventListener('mouseleave', function() {
                this.style.transform = this.classList.contains('wave-left')
                    ? 'rotate(180deg) scaleY(-1)'
                    : 'translateY(0)';
            });
        });
        
        // Catalog button animation
        const catalogBtn = document.querySelector('.catalog-button');
        if (catalogBtn) {
            catalogBtn.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.02)';
                this.style.transition = 'transform 0.3s ease';
            });
            
            catalogBtn.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        }
    }

    // Performance optimization - throttle scroll events
    function throttle(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    // Optimize scroll events
    const optimizedScroll = throttle(function() {
        // Add any scroll-based functions here
    }, 100);

    window.addEventListener('scroll', optimizedScroll);

    // Image preloading for better performance
    function preloadImages() {
        const imagesToPreload = [
            'images/hero-bg.png',
            'images/products/amour.png',
            'images/products/vospominanie.png',
            'images/products/ochertanie.png',
            'images/products/flor.png'
        ];
        
        imagesToPreload.forEach(src => {
            const img = new Image();
            img.src = src;
        });
    }

    // Preload images after page load
    window.addEventListener('load', preloadImages);

    // Handle window resize
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            // Reinitialize parallax on resize
            if (window.innerWidth > 768) {
                initParallaxEffect();
            }
        }, 250);
    });

    // Add loading class removal
    window.addEventListener('load', function() {
        document.body.classList.add('loaded');
        
        // Remove loading screen if exists
        const loader = document.querySelector('.loader');
        if (loader) {
            setTimeout(() => {
                loader.style.opacity = '0';
                setTimeout(() => {
                    loader.style.display = 'none';
                }, 500);
            }, 500);
        }
    });

    // Console Easter egg
    console.log('%c CHOIS ', 'background: #791227; color: #fffae6; font-size: 24px; padding: 10px;');
    console.log('%c Fall in love with yourself every day ', 'color: #791227; font-size: 14px;');

})();