// サイドバーのトグル
document.addEventListener("turbo:load", function() {
    const accountButton = document.getElementById("avatar");
    const dropdownMenu = document.getElementById("dropdown-menu");
    accountButton.addEventListener("click", function(e) {
      e.preventDefault();
      dropdownMenu.classList.toggle("show");
    });
});