import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswerChannel", room: "answer_room" }, {
  connected() {
    console.log('Connected');
  },

  disconnected() {
    console.log('Disconnected')
  },

  received(data) {
    let answerPartial = $('.empty-answer').clone();
    let url = 'questions/' + data.question_id + '/answers/' + data.id + '/vote'

    answerPartial.removeClass('empty-answer');
    answerPartial.addClass('answer-card');
    answerPartial.css('display', '');
    answerPartial.find('.answer-body').text(data.body);
    answerPartial.find('.answer-rate-number').attr("id", "rate-number-" + data.id);
    answerPartial.find('.answer-vote-buttons').attr("id", "vote-buttons-" + data.id);
    answerPartial.find('.answer-vote-buttons').find('.button_to').attr('action', url)
    $('#answers').append(answerPartial);
  }
});
