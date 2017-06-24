var USER_AGENT = "Mozilla/5.0 (Macintosh Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"

var casper = require('casper').create()
casper.userAgent(USER_AGENT)

var itemId = casper.cli.get(0)
var itemUrl = "https://item.taobao.com/item.htm?id=" + itemId
casper.start(itemUrl)

// 点击 '累计评论'
casper.then(function () {
  this.evaluate(function () {
    var reviewTab = document.querySelector('.tb-tab-anchor[data-index="1"]')
    reviewTab.click()
  })
})

// 点击 '图片'
casper.then(function () {
  this.waitForSelector('li[data-kg-rate-filter-val="3"] input[type="radio"]', function () {
    this.evaluate(function () {
      var picRadioSelector = 'li[data-kg-rate-filter-val="3"] input[type="radio"]'
      var picRadio = document.querySelector(picRadioSelector)
      picRadio.click()
    })
  })
})

// 确保评论已切换到 '图片' tab
casper.then(function () {
  // // 评论请求已返回
  this.waitForResource("feedRateList.htm")

  this.wait(5000, function () {
    var result = this.evaluate(function () {
      var title = document.querySelector(".tb-main-title").textContent.trim()
      var coverImages = document.querySelectorAll(".tb-thumb img")
      var coverUrls = Array.prototype.map.call(coverImages, function (img) {
        return img.src.replace("_50x50.jpg", "")
      })

      var totalCount = parseInt(document.querySelector('[data-kg-rate-stats="pic"]').textContent.match(/\d+/)[0])
      // TODO 抓取后面几页评论
      var reviewItems = document.querySelectorAll(".kg-rate-ct-review-item")

      var reviews = Array.prototype.map.call(reviewItems, function (review) {
        var no = review.id.split("-")[1]
        var avatar = review.querySelector("img.avatar").src
        var name = review.querySelector("div").textContent.trim()
        var revisionItems = review.querySelectorAll(".review-details .tb-rev-item")

        var revisions = Array.prototype.map.call(revisionItems, function (revision) {
          var no = revision.getAttribute("data-id")
          // 去掉 '[追加评论]'
          var contentNodes = revision.querySelector(".tb-tbcr-content").childNodes
          var content = contentNodes[contentNodes.length - 1].textContent.trim()

          var photos = Array.prototype.map.call(revision.querySelectorAll(".photo-item img"), function (photo) {
            return photo.src.replace("_40x40.jpg", "")
          })

          var date = revision.querySelector(".tb-r-date").textContent.trim()

          return {
            revision_no: no,
            content: content,
            photos: photos,
            date: date,
          }
        })

        return {
          // outerHTML: review.outerHTML,
          review_no: no,
          avatar: avatar,
          name: name,
          revisions: revisions,
        }
      })

      return {
        title: title,
        cover_urls: coverUrls,
        reviews: reviews,
        total_count: totalCount,
      }
    })

    // this.capture('screenshot.png')

    // 输出 JSON
    require("utils").dump(result)
  })
})

casper.run()
