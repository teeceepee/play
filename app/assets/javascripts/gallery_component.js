
var rotateDegree = function (el) {
  var st = window.getComputedStyle(el, null);
  var tr = st.getPropertyValue("-webkit-transform") ||
    st.getPropertyValue("-moz-transform") ||
    st.getPropertyValue("-ms-transform") ||
    st.getPropertyValue("-o-transform") ||
    st.getPropertyValue("transform") ||
    "FAIL";

  // With rotate(30deg)...
  // matrix(0.866025, 0.5, -0.5, 0.866025, 0px, 0px)
  console.log('Matrix: ' + tr);

  // rotation matrix - http://en.wikipedia.org/wiki/Rotation_matrix

  var values = tr.split('(')[1].split(')')[0].split(',');
  var a = values[0];
  var b = values[1];
  var c = values[2];
  var d = values[3];

  var scale = Math.sqrt(a * a + b * b);

  console.log('Scale: ' + scale);

  // arc sin, convert from radians to degrees, round
  var sin = b / scale;
  // next line works for 30deg but not 130deg (returns 50);
  // var angle = Math.round(Math.asin(sin) * (180/Math.PI));
  var angle = Math.round(Math.atan2(b, a) * (180 / Math.PI));

  console.log('Rotate: ' + angle + 'deg');
  return angle
}


var Gallery = function (imgSrc) {
  this.body = $(document.body)
  this.backdrop = null
  this.isShown = null

  this.originalBodyPad = null
  this.scrollbarWidth = 0

  this.imgSrc = imgSrc
}

Gallery.BODY_CLASS = "gallery-open"

Gallery.OPERTATIONS =
  '<div class="operations">' +
    '<div class="operation gallery-rotate"><i class="fa fa-rotate-right"></i></div>' +
    '<div class="operation gallery-baidu"><i class="fa fa-search"></i></div>' +
    '<div class="operation gallery-google"><i class="fa fa-google"></i></div>' +
    '<div class="operation gallery-close"><i class="fa fa-close"></i></div>' +
  '</div>'
Gallery.TEMPLATE =
  '<div class="gallery">' +
    '<div class="img-container"><img></div>' +
    Gallery.OPERTATIONS +
  '</div>'

Gallery.BAIDU_IMAGE_SEARCH_URL = "https://image.baidu.com/n/pc_search"
Gallery.GOOGLE_IMAGE_SEARCH_URL = "https://www.google.com.hk/searchbyimage"

Gallery.prototype.show = function () {
  this.checkScrollbar()
  this.setScrollbar()

  this.body.addClass(Gallery.BODY_CLASS)
  this.addBackdrop()

  this.el = $(Gallery.TEMPLATE).appendTo(this.body)
  this.el.find("img").attr("src", this.imgSrc)

  this.listenEvents()
}

Gallery.prototype.hide = function () {
  this.resetScrollbar()

  this.body.removeClass(Gallery.BODY_CLASS)
  this.removeBackdrop()

  this.unbindEvents()

  this.el.remove()
}

Gallery.prototype.rotateRight = function () {
  var img = this.el.find(".img-container img")
  var currentDegree = rotateDegree(img.get(0))
  var deg = currentDegree + 90
  var value = "rotate(" + deg.toString() + "deg)"
  img.css("transform", value)
}

Gallery.prototype.listenEvents = function () {
  this.el.on("click", function (e) {
    if ($(e.target).is('.img-container, .operations')) {
      this.hide()
    }
  }.bind(this))

  this.el.one("click", ".gallery-close", function () {
    this.hide()
  }.bind(this))

  this.el.on("click", ".gallery-rotate", function () {
    this.rotateRight()
  }.bind(this))

  this.el.on("click", ".gallery-baidu", function () {
    var a = document.createElement('a')
    a.href = Gallery.BAIDU_IMAGE_SEARCH_URL
    a.search = $.param({"queryImageUrl": Gallery.thumbImgSrc(this.imgSrc)})
    window.open(a.href, '_blank')
  }.bind(this))

  this.el.on("click", ".gallery-google", function () {
    var a = document.createElement('a')
    a.href = Gallery.GOOGLE_IMAGE_SEARCH_URL
    a.search = $.param({"image_url": Gallery.thumbImgSrc(this.imgSrc)})
    console.log(a.href);
    window.open(a.href, '_blank')
  }.bind(this))
}

Gallery.prototype.unbindEvents = function () {
  this.el.off("click", ".gallery-rotate")
}

// Backdrop
Gallery.prototype.addBackdrop = function () {
  this.backdrop = $("<div></div>").addClass("backdrop").appendTo(this.body)
}

Gallery.prototype.removeBackdrop = function () {
  this.backdrop && this.backdrop.remove()
  this.backdrop = null
}

// Scrollbar width
Gallery.prototype.checkScrollbar = function () {
  var fullWindowWidth = window.innerWidth
  if (!fullWindowWidth) { // workaround for missing window.innerWidth in IE8
    var documentElementRect = document.documentElement.getBoundingClientRect()
    fullWindowWidth = documentElementRect.right - Math.abs(documentElementRect.left)
  }
  this.bodyIsOverflowing = document.body.clientWidth < fullWindowWidth
  this.scrollbarWidth = this.measureScrollbar()
}

Gallery.prototype.setScrollbar = function () {
  var bodyPad = parseInt((this.body.css('padding-right') || 0), 10)
  this.originalBodyPad = document.body.style.paddingRight || ''
  if (this.bodyIsOverflowing) this.body.css('padding-right', bodyPad + this.scrollbarWidth)
}

Gallery.prototype.resetScrollbar = function () {
  this.body.css('padding-right', this.originalBodyPad)
}

Gallery.prototype.measureScrollbar = function () { // thx walsh
  var scrollDiv = document.createElement('div')
  scrollDiv.className = 'modal-scrollbar-measure'
  this.body.append(scrollDiv)
  var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
  this.body[0].removeChild(scrollDiv)
  return scrollbarWidth
}

// image source
Gallery.thumbImgSrc = function (imgSrc) {
  return imgSrc.replace("sinaimg.cn/large", "sinaimg.cn/mw600")
}
