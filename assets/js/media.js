// import tippy from "tippy.js"
// import "tippy.js/dist/tippy.css";
// import "tippy.js/themes/light-border.css";

document.addEventListener("DOMContentLoaded", function() {
  let songInfos = document.querySelectorAll(".song-info")

  songInfos.forEach(function(songInfo) {
    songInfo.addEventListener("click", function(e) {
      e.preventDefault()
      e.stopPropagation()

      // Hide all actions first
      document.querySelectorAll(".song-data.shown-actions").forEach(function(el) {
        el.classList.remove("shown-actions")
        el.classList.add("hidden-actions")
      })

      document.querySelectorAll(".song-data.active-mobile-actions").forEach(function(el) {
        el.classList.remove("active-mobile-actions")
        el.classList.add("inactive-mobile-actions")
      })

      // Then display actions on tapped song
      this.parentNode.classList.add("shown-actions")
      this.parentNode.classList.remove("hidden-actions")

      this.parentNode.previousElementSibling.classList.add("active-mobile-actions")
      this.parentNode.previousElementSibling.classList.remove("inactive-mobile-actions")
    })
  })

  let closeBtns = document.querySelectorAll(".mobile-close")

  closeBtns.forEach(function(btn) {
    btn.addEventListener("click", function(e) {
      e.preventDefault()
      e.stopPropagation()

      this.parentNode.classList.remove("active-mobile-actions")
      this.parentNode.classList.add("inactive-mobile-actions")

      this.parentNode.nextElementSibling.classList.remove("shown-actions")
      this.parentNode.nextElementSibling.classList.add("hidden-actions")
    })
  })
})
