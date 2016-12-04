
var socket = new WebSocket("ws://localhost:3000/ws/echo_server")

socket.addEventListener("open", function (e) {
  socket.send("ping")

  $(document).ready(function () {
    $("#form").on("submit", function (e) {
      e.preventDefault()

      var text = $("#text").val()
      if (text.length > 0 && socket.readyState == WebSocket.OPEN) {
        socket.send(text)
        $("#text").val("")
      }
    })

    $("#form .close-socket").on("click", function () {
      $("#text").prop("disabled", true)
      socket.close()
    })
  })
})

socket.addEventListener("message", function (e) {
  console.log("Message: " + e.data)
  $('<div class="alert alert-info"></div>').text(e.data).hide().appendTo($(".messages")).fadeIn()
})

socket.addEventListener("close", function (e) {
  console.log("on close")
})

socket.addEventListener("error", function (e) {
  console.log("on error")
})
