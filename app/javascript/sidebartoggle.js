// サイドバー：ToDoのトグル
document.addEventListener("turbo:load", function() {
    const accountButton = document.getElementById("todo");
    const dropdownMenu = document.getElementById("todo-dropdown-menu");
    accountButton.addEventListener("click", function(e) {
      e.preventDefault();
      dropdownMenu.classList.toggle("show");
    });
});

// サイドバー：アバターのトグル
document.addEventListener("turbo:load", function() {
  const accountButton = document.getElementById("avatar");
  const dropdownMenu = document.getElementById("avatar-dropdown-menu");
  accountButton.addEventListener("click", function(e) {
    e.preventDefault();
    dropdownMenu.classList.toggle("show");
  });
});