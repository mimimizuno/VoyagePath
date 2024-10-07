// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// ナイトモード切り替え
document.addEventListener('turbo:load', function() {
  const toggles = document.querySelectorAll('.night-mode-toggle'); // クラスを使って要素を取得
  
  // ページが読み込まれたときに、ローカルストレージの状態を確認してナイトモードを適用
  if (localStorage.getItem('night-mode') === 'enabled') {
    document.body.classList.add('night-mode');
  }

  // ナイトモードのトグルボタンのクリックイベントを各ボタンに設定
  toggles.forEach(function(toggle) {
    toggle.addEventListener('click', function() {
      document.body.classList.toggle('night-mode');
      
      // ナイトモードが有効ならローカルストレージに保存
      if (document.body.classList.contains('night-mode')) {
        localStorage.setItem('night-mode', 'enabled');
      } else {
        localStorage.removeItem('night-mode');
      }
    });
  });
});

// サイドバーのトグル
document.addEventListener("turbo:load", function() {
  const accountButton = document.getElementById("avatar");
  const dropdownMenu = document.getElementById("dropdown-menu");
  accountButton.addEventListener("click", function(e) {
    e.preventDefault();
    dropdownMenu.classList.toggle("show");
  });
});

// グラフの描画
document.addEventListener("turbo:load", function() {
  let ctx = document.getElementById('completion-chart').getContext('2d');
  let chart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: [],
      datasets: [{
        label: 'Completion Rate',
        data: [],
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 1
      }]
    }
  });

  // ユーザーIDを取得
  let userId = document.getElementById('completion-chart-container').getAttribute('data-user-id');

  function updateChart(period) {
    fetch(`/users/${userId}/completion_rates?period=${period}`)
      .then(response => response.json())
      .then(data => {
        let labels = data.map(entry => entry.date);
        let completionRates = data.map(entry => entry.completion_rate);

        chart.data.labels = labels;
        chart.data.datasets[0].data = completionRates;
        chart.update();
      });
  }

  // ボタンのクリックイベントリスナー
  document.getElementById('weekly-btn').addEventListener('click', function() {
    updateChart('weekly');
  });

  document.getElementById('monthly-btn').addEventListener('click', function() {
    updateChart('monthly');
  });

  document.getElementById('yearly-btn').addEventListener('click', function() {
    updateChart('yearly');
  });

  // 初期表示は週ごと
  updateChart('weekly');
});