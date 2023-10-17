document.addEventListener('DOMContentLoaded', function() {
  let dropdownToggles = document.querySelectorAll('.dropdown-toggle');
  dropdownToggles.forEach(toggle => {
    toggle.addEventListener('click', function() {
      let dropdownContent = this.nextElementSibling;
      dropdownContent.classList.toggle('hidden');
    });
  });
});