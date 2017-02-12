# Sina CDN domains: wx1.sinaimg.cn wx2.sinaimg.cn wx3.sinaimg.cn wx4.sinaimg.cn
# Sina CDN versions: square large
class Picture < ApplicationRecord
  attr_accessor :file

  ## validations
  validates_presence_of :filename, :pid

  def sinaimg_url(version = 'large')
    "https://wx1.sinaimg.cn/#{version}/#{self.pid}#{self.extname}"
  end

  def extname
    if File.extname(self.filename) == '.gif'
      '.gif'
    else
      '.jpg'
    end
  end

  def upload_picture
    if self.file.present?
      self.filename = self.file.original_filename
      self.pid = Weibo.new.upload_picture(self.file.tempfile, self.file.content_type)
    end
  end
end
