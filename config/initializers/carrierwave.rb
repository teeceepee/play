CarrierWave.configure do |config|
  config.storage           = :aliyun
  config.aliyun_access_id  = Settings.oss.access_key_id
  config.aliyun_access_key = Settings.oss.access_key_secret

  config.aliyun_bucket     = 'athena01'
  config.aliyun_internal   = false
  config.aliyun_area       = 'cn-shanghai'
  config.aliyun_host       = 'https://athena01.oss-cn-shanghai.aliyuncs.com'
  config.aliyun_private_read = true
end
