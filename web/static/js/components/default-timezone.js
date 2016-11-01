$(document).on('turbolinks:load', function () {
  let timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  let element = $('#event_timezone');
  let content = element.val();

  if (!content || content == "") {
    element.val(timezone)
  }
});
