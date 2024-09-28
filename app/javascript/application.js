// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// メニュー操作

// トグルリスナーを追加してクリックをリッスンする
document.addEventListener("turbo:load", function() {
    let account = document.querySelector("#account");
    if (account) {
      account.addEventListener("click", function(event) {
        event.preventDefault();
        let menu = document.querySelector("#dropdown-menu");
        menu.classList.toggle("active");
      });
    }
  });