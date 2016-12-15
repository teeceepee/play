var chatChannel = App.cable.subscriptions.create("ChatChannel", {
  connected: function () {
  },

  received: function (data) {
    console.log("Message: " + data.message)
  },

  say: function (message) {
    this.perform("say", {message: message})
  }
})
