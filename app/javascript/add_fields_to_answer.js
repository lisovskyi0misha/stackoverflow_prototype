$(document).on('click', '#add-file-to-answer-button', function() {
    $('.file-fields').append('<div class="mb-3"><input multiple="multiple" class="form-control" type="file" name="answer[files][]" id="answer_files"></input></div');
  });
