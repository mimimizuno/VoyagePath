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