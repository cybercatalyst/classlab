const CodeMirror = require('codemirror/lib/codemirror');
require('codemirror/mode/xml/xml');
require('codemirror/mode/markdown/markdown');

// fix for turbolinks + apply codemirror for markdown
$(document).on('turbolinks:load', function() {
  let code_type = '';
  $('.code-mirror-markdown').each(function(index) {
    const elem = $(this)
    elem.attr('id', 'code-' + index);
    CodeMirror.fromTextArea(elem[0], {
      mode: 'markdown',
      theme: 'default',
      lineNumbers: false,
      lineWrapping: true,
      tabSize: 2,
      viewportMargin: Infinity,
      tabMode: 'indent'
      }
    );
  });
});
