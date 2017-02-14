class Weibo
  UPLOAD_URL = 'http://picupload.service.weibo.com/interface/pic_upload.php?' +
  'cb=http%3A%2F%2Fwww.weibo.com%2F&url=0&markpos=1&logo=&nick=0&marks=1&app=miniblog&s=rdxt'
  COOKIE_STRING_KEY = 'weibo:cookie_string'
  USERNAME_PASSWORD_KEY = 'weibo:username_password'

  def initialize
  end

  def upload_picture(file, content_type)
    form_file = HTTP::FormData::File.new(file, mime_type: content_type)
    resp = HTTP.headers(cookie: cookie_string).post(UPLOAD_URL, form: {pic1: form_file})

    redirect_url = URI(resp.headers['Location'] || '')
    query = Rack::Utils.parse_query(redirect_url.query)
    query['pid']
  end

  def cookie_string
    @cookie_string ||= self.class.get_cookie_string
  end

  def self.set_cookie_string(cookie_string)
    Redis.current.set(COOKIE_STRING_KEY, cookie_string)
  end

  def self.get_cookie_string
    Redis.current.get(COOKIE_STRING_KEY)
  end

  def self.set_username_password(username, password)
    encrypted = encryptor.encrypt_and_sign([username, password])
    Redis.current.set(USERNAME_PASSWORD_KEY, encrypted)
  end

  # @return [Array]
  def self.get_username_password
    encrypted = Redis.current.get(USERNAME_PASSWORD_KEY)
    if encrypted
      encryptor.decrypt_and_verify(encrypted)
    else
      []
    end
  end

  def self.encryptor
    secret = Rails.application.secrets.secret_key_base
    ActiveSupport::MessageEncryptor.new(secret, serializer: JSON)
  end
end
