import consumer from "./consumer"

if (typeof current_room === "undefined") {
  let room = $('.question-index').attr('class')
  consumer.subscriptions.create({ channel: "QuestionChannel", room: room }, {
    connected() {
      console.log('Connected to question index')
    },
  
    disconnected() {
      console.log('Disconnected')
    },
  
    received(data) {
      console.log(data)
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
