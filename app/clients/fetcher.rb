class Fetcher
  IOS_USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0 Mobile/14B100 Safari/602.1'

  def self.fetch_all
    Jiandan.fetch_new
    Hupu.fetch_recent_news
    # Weibo.fetch_cookie
  end

  def self.bitcoin
    url = 'https://data.btcchina.com/data/ticker'
    resp = HTTP.get(url, params: {market: 'btccny'})
    text = YAML.dump(JSON.parse(resp))

    notifier = Slack::Notifier.new Settings.slack.bitcoin.webhook_url, {
      channel: '#bitcoin',
      username: 'bot',
      icon_emoji: ':moneybag:',
    }
    notifier.ping(text)
  end
end
