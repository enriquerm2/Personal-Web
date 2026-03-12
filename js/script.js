// Simple smooth scroll for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', function (e) {
    e.preventDefault();
    const targetId = this.getAttribute('href');
    if (targetId === '#') return;
    const targetElement = document.querySelector(targetId);
    if (targetElement) {
      targetElement.scrollIntoView({
        behavior: 'smooth'
      });
    }
  });
});

// Implementation of a simple header scroll effect
const header = document.querySelector('header');
window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        header.classList.add('bg-[#0a0a0a]/95', 'py-3');
        header.classList.remove('bg-[#0a0a0a]/80', 'py-0');
    } else {
        header.classList.add('bg-[#0a0a0a]/80');
        header.classList.remove('bg-[#0a0a0a]/95', 'py-3');
    }
});

// Contact form handling
const contactForm = document.querySelector('form');
if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const submitButton = contactForm.querySelector('[data-purpose="submit-button"]');
        const originalText = submitButton.textContent;
        
        submitButton.disabled = true;
        submitButton.textContent = 'Enviando...';
        
        // Simulate an API call
        setTimeout(() => {
            alert('¡Gracias! He recibido tu mensaje y me pondré en contacto contigo pronto.');
            contactForm.reset();
            submitButton.disabled = false;
            submitButton.textContent = originalText;
        }, 1500);
    });
}

