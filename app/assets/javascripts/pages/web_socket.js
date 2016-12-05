
var echoSocket = new WebSocket("ws://localhost:3000/ws/echo_server")
var broadcastSocket = new WebSocket("ws://localhost:3000/ws/broadcast_server")

var sockets = {
  echo: echoSocket,
  broadcast: broadcastSocket,
}

Object.keys(sockets).forEach(function (k) {
  var socket = sockets[k]

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
})

$(document).ready(function () {
  $("#form").on("submit", function (e) {
    e.preventDefault()

    var text = $("#text").val()
    var socket = sockets[$("#form input[name=socket]:checked").val()]

    if (text.length > 0 && socket.readyState == WebSocket.OPEN) {
      socket.send(text)
      $("#text").val("")
    }
  })

  $("#form .close-socket").on("click", function () {
    $("#text").prop("disabled", true)
    for (k in sockets) {
      sockets[k].close()
    }
  })
})
