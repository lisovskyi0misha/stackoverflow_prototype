import consumer from "./consumer"

let current_room = $('.question').attr('id')

if (typeof current_room === "undefined") {
  let room = $('.question-index').attr('class')
  consumer.subscriptions.create({ channel: "QuestionChannel", room: room }, {
    connected() {
    },
  
    disconnected() {
    },
  
    received(data) {
      let questionPartial = $('.empty-question').clone();
      let url = 'questions/' + data.question_id + '/answers/' + data.id + '/vote'
  
      questionPartial.removeClass('empty-question');
      questionPartial.addClass('question')
      questionPartial.css('display', '');
      questionPartial.find('.question-title').text(data.title);
      questionPartial.find('.question-details').attr("action", 'questions/' + data.id);
      $('.question-index').append(questionPartial);
    }
  });
};
