// アバターの選択
document.addEventListener("turbo:load", function() {
    const radios = document.querySelectorAll(".avatar-radio");
    let lastChecked;

    radios.forEach(function(radio) {
      radio.addEventListener('click', function() {
        if (lastChecked === radio) {
          radio.checked = false;
          lastChecked = null;
        } else {
          lastChecked = radio;
        }
      });
    });
});