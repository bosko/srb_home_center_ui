// import tippy from "tippy.js"
// import "tippy.js/dist/tippy.css";
// import "tippy.js/themes/light-border.css";

document.addEventListener("DOMContentLoaded", function() {
  let songInfos = document.querySelectorAll(".song-info")

  songInfos.forEach(function(songInfo) {
    songInfo.addEventListener("click", function(e) {
      e.preventDefault()
      e.stopPropagation()

      if (this.parentNode.classList.contains('shown-actions')) {
        this.parentNode.classList.remove("shown-actions")
        this.parentNode.classList.add("hidden-actions")

        this.parentNode.previousElementSibling.className = "inactive-mobile-actions"
      } else {
        this.parentNode.classList.add("shown-actions")
        this.parentNode.classList.remove("hidden-actions")

        this.parentNode.previousElementSibling.className = "active-mobile-actions"
      }
    })
  })
})
