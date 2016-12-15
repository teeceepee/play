//= require cable

$(document).ready(function () {
  chatChannel.received = function (data) {
    $('<div class="alert alert-info"></div>').text(data.message).hide().appendTo($(".messages")).fadeIn()
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
