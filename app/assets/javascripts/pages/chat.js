//= require cable

var canNotify = typeof(Notification) !== "undefined"

if (canNotify) {
  Notification.requestPermission(function (permission) {
    console.log("permission: " + permission)
  })
}

$(document).ready(function () {
  var displayNo = function (message) {
    if (!canNotify) {
      return
    }

    var n = new Notification("New message", {
      icon: 'https://i0.hdslb.com/bfs/archive/07d57f5ead6702d0f5ef9d5b7e5d778b9ce67062.jpg',
      body: message,
      tag: "tag",
    })

    n.onclick = function (e) {
      console.log(e)
    }

    n.onerror = function (e) {
      console.log(e)
    }
  }

  chatChannel.received = function (data) {
    var message = data.message
    $('<div class="alert alert-info"></div>').text(message).hide().appendTo($(".messages")).fadeIn()

    displayNo(message)
  }

  $("#form").on("submit", function (e) {
    e.preventDefault()
    var text = $("#text").val()

    if (text.length > 0) {
      chatChannel.say(text)
      $("#text").val("")
    }
  })
})
