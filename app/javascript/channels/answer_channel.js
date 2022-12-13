import consumer from "./consumer"

  let current_room = $('.question').attr('id')

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
  
  } else {
    consumer.subscriptions.create({ channel: "QuestionChannel", room: current_room }, {
      connected() {
        console.log('Connected to ' + current_room);
      },
    
      disconnected() {
        console.log('Disconnected')
      },
    
      received(data) {
        if (data.type == 'comment') {
          $('.comments').append('<p>' + data.object.body + '</p>')
        } else {
          answer = data.object
          let userId = $('.user_id').attr('id')
          let answerPartial = $('.empty-answer').clone();
          let url = 'questions/' + answer.question_id + '/answers/' + answer.id + '/vote'
          if (answer.id == userId) { return false }
      
          answerPartial.removeClass('empty-answer');
          answerPartial.addClass('answer-card');
          answerPartial.css('display', '');
          answerPartial.find('.answer-body').text(answer.body);
          answerPartial.find('.answer-rate-number').attr("id", "rate-number-" + answer.id);
          answerPartial.find('.answer-vote-buttons').attr("id", "vote-buttons-" + answer.id);
          if (userId == '') {
            answerPartial.find('.btn-outline-success').prop('disabled', true)
            answerPartial.find('.btn-outline-danger').prop('disabled', true)
          };
          answerPartial.find('.answer-vote-buttons').find('.button_to').attr('action', url)
          $('#answers').append(answerPartial);
        };
      }
    });
  };

