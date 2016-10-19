// Live chat - used for classroom events
// Used e.g. on:
// * http://localhost:4000/classroom/event_id/dashboard
// * http://localhost:4000/classroom/event_id/event_messages
import socket from './socket'

$(document).on('turbolinks:load', function () {
  $('[data-page-reload]').each(function(index, element) {
    let refreshEvent = $(element).data('page-reload');
    let pageReloadChannel = socket.channel(`page_reload:${refreshEvent}`, {});

    pageReloadChannel.join()
      .receive('ok', resp => { console.log('Monitoring event_message for event ') })
      .receive('error', resp => { console.log('Unable to join', resp) });

    pageReloadChannel.on('reload', () => {
      console.log('reload')
      Turbolinks.visit(location, { action: 'replace' })
    });
  });
});

$(document).on('turbolinks:before-visit', function () {
  $('[data-page-reload]').each(function(index, element) {
    let refreshEvent = $(element).data('page-reload');
    let pageReloadChannel = socket.channel(`page_reload:${refreshEvent}`, {});

    pageReloadChannel.leave();
  });
});

