// fix for turbolinks + delete actions
$(document).on('turbolinks:load', function() {
  $('[data-submit^=parent]').each(function () {
    $(this).on('click', function (event) {
      event.preventDefault();

      var deleteButton = $(this);
      var message = deleteButton.data("confirm") || "Do you really want to delete the selected entry?";
      var title = deleteButton.data("confirmtitle") || "Remove entry";
      var form = this.parentNode;
      var modalElem = $('#baseModal');
      var sendForm = function () {
        modalElem.modal('hide');
        form.submit();
      }

      if (!deleteButton.data("toggle")) {
        sendForm();

        return false;
      }

      // set content
      modalElem.on('show.bs.modal', function () {
        modalElem.find('.modal-content').html(`
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
            <h4 class="modal-title" id="gridModalLabel">${title}</h4>
          </div>
          <div class="modal-body">
            <p>${message}</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-action="true">Löschen</button>
          </div>
        `);

        modalElem.find('button[data-action="true"]').on('click', sendForm);
      });

      // open modal
      modalElem.modal('show');
    });
  });
});
