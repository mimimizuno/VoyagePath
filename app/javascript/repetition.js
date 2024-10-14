document.addEventListener("turbo:load", function() {
  const repetitionTypeSelect = document.getElementById("repetition_type_select");
  const weeklyRepetitionDiv = document.getElementById("weekly_repetition");
  const monthlyRepetitionDiv = document.getElementById("monthly_repetition");

  // repetitionTypeSelectが存在する場合のみ処理を行う
  if (repetitionTypeSelect) {
    // 繰り返しのタイプに基づいてフィールドを切り替え
    function toggleRepetitionFields() {
      if (repetitionTypeSelect.value === 'weekly') {
        weeklyRepetitionDiv.style.display = 'block';
        monthlyRepetitionDiv.style.display = 'none';
      } else if (repetitionTypeSelect.value === 'monthly') {
        weeklyRepetitionDiv.style.display = 'none';
        monthlyRepetitionDiv.style.display = 'block';
      } else {
        weeklyRepetitionDiv.style.display = 'none';
        monthlyRepetitionDiv.style.display = 'none';
      }
    }

    repetitionTypeSelect.addEventListener("change", toggleRepetitionFields);
    toggleRepetitionFields(); // 初期表示に基づいて切り替え
  }
});