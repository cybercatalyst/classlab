// Highlights source on the page per JavaScript.
// Enables highlighting for <pre><code>.
// Needs a corresponding css file.
//
// Homepage: https://highlightjs.org/
// Source: https://github.com/isagalaev/highlight.js
// NPM: highlightjs
import hljs from "highlightjs/highlight.pack.min"

$(document).on("turbolinks:load", function() {
  $('pre code').each(function (i, block) {
    hljs.highlightBlock(block);
  });
});
