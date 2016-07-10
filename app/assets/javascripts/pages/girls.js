//= require jquery_lazyload/jquery.lazyload

$(document).ready(function () {
  $('img.girl-image').lazyload({
    effect : "fadeIn",
    placeholder:"data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
    //threshold       : 0,
    //failure_limit   : 0,
    //event           : "scroll",
    //effect          : "show",
    //container       : window,
    //data_attribute  : "original",
    //skip_invisible  : false,
    //appear          : null,
    //load            : null,
  });
});
