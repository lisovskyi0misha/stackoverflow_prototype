$(document).on('click', '#add-file-to-answer-button', function() {
    $('.question-file-fields').append('<div class="mb-3"><input multiple="multiple" class="form-control" type="file" name="question[files][]" id="question_files"></input></div');
  });
