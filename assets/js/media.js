import tippy from "tippy.js"
import "tippy.js/dist/tippy.css";
import "tippy.js/themes/light-border.css";

document.addEventListener("DOMContentLoaded", function() {
  tippy('.queue-song', {
    allowHTML: true,
    interactive: true,
    trigger: "click",
    theme: "light-border",
    content(reference) {
      const index = reference.getAttribute("data-queue-index");
      const template = document.getElementById("song-popup-template");
      return template.innerHTML.replaceAll("{song-index}", index)
    }
  })
});
