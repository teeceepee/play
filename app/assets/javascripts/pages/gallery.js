//= require gallery_component

var src = "http://www.shoac.com.cn/uploadfile/215_300/2016103111220572556065.jpg"
var g = new Gallery(src)

$(".open").on("click", function () {
  g.show()
})
