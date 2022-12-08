import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswerChannel", room: "answer_room" }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Disconnected')
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('Recieved')
    console.log(data)
  }
});
