var mumuki = mumuki || {};

(function (mumuki) {
  function ResultsBox(submissionsResults) {
    this.submissionsresultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
  }

  ResultsBox.prototype = {
    waiting: function () {
      console.log('submitting solution');
      this.submissionsresultsArea.html(this.processingTemplate.html());
    },
    success: function (data) {
      this.submissionsresultsArea.html(data);
    },
    error: function (error) {
      this.submissionsresultsArea.html('<pre>' + error + '</pre>');
    },
    done: function () {
      mumuki.pin.scroll();
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var submitButton = $('.btn-submit');
    var submissionControls = $('.submission-control');

    var resultsBox = new ResultsBox(submissionsResults);

    $('form.new_solution').on('ajax:beforeSend', function (event, xhr, settings) {
      document.prevSubmitState = submitButton.html();
      submitButton.html('<i class="fa fa-refresh fa-spin"></i> ' + submitButton.attr('data-waiting'));
      submissionControls.attr('disabled', 'disabled');
      resultsBox.waiting();
    }).on('ajax:complete', function (xhr, status) {
      submitButton.html(document.prevSubmitState);
      submissionControls.removeAttr('disabled');
      resultsBox.done();
      $('#messages-tab').removeClass('hidden');
    }).on('ajax:success', function (xhr, data, status) {
      resultsBox.success(data);
    }).on('ajax:error', function (xhr, status, error) {
      var message = error === "error" ? 'Network error :( Please check your internet connection and try again' : error;
      resultsBox.error(message);
    });
  });
})(mumuki);
