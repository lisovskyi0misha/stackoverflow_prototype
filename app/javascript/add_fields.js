$('#add-file-button').click(function() {
  $('.file-fields').append('<input multiple="multiple" class="form-control" type="file" name="question[files][]" id="question_files"></input>');
});
