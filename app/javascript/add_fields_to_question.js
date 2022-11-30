$(document).ready(function() {
  $('#add-files-to-question-button').click(function() {
    $('.file-fields').append('<div class="mb-3"><input multiple="multiple" class="form-control" type="file" name="question[files][]" id="question_files"></input></div');
  });
});
