document.addEventListener("turbo:load", function() {
  // data-completion-rate属性から達成率を取得
  const cardBody = document.querySelector('#completion-rate-card .card-body');
  const completionRate = cardBody.getAttribute('data-completion-rate');
  
  // 円グラフを描画
  const ctx = document.getElementById('completionRateChart').getContext('2d');
  const data = {
    labels: ['完了', '未完了'],
    datasets: [{
      data: [completionRate, 100 - completionRate],
      // 完了がアクセントカラー、未完了がメインカラー
      backgroundColor: ['#A0E54A', '#9AC1EF'],
    }]
  };
  const config = {
    type: 'doughnut',
    data: data,
  };

  new Chart(ctx, config);
});