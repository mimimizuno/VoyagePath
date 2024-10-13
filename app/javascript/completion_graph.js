// グラフの描画
document.addEventListener("turbo:load", function() {
    let ctx = document.getElementById('completion-chart').getContext('2d');
    let chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: [],
        datasets: [{
          label: '達成率',
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