//= require jquery_lazyload/jquery.lazyload
//= require jquery_lazyload/jquery.scrollstop
//= require gallery_component

$(document).ready(function () {
  $("img.girl-image").lazyload({
    effect : "fadeIn",
    placeholder:"data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
    load: function () {
      $(this).data({"loaded": true})
    },
    event: "scrollstop"
    //threshold       : 0,
    //failure_limit   : 0,
    //event           : "scroll",
    //effect          : "show",
    //container       : window,
    //data_attribute  : "original",
    //skip_invisible  : false,
    //appear          : null,
    //event           : null,
  });

  $(document).on("click", "img.girl-image", function (e) {
    var el = $(e.target)
    if (el.data("loaded") && el.attr("src")) {
      var g = new Gallery(el.attr("src"))
      g.show()
    }
  })
});
