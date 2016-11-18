// Form submit disabler
//
// Simple hack to avoid multiple form submits.
// After pressing the submit button, the button is disabled
// and a spinner is appended to the button text.

$(document).on("turbolinks:load", function() {
  $('form').each(() => {
    const $form = $(this);
    let submitting = false;
    const onSubmitHandler = (event) => {
      if (submitting) {
        event.preventDefault();
        return;
      }
      submitting = true;

      const $submitBtn = $form.find("[type=submit]");

      $submitBtn.prop('disabled', true);
    };

    $form.on('submit', onSubmitHandler);
  });
});