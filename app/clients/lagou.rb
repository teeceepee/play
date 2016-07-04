
module Lagou
  POSITION_URL_BASE = 'http://www.lagou.com/jobs/positionAjax.json'

  def self.test
    positions do |position|
      Position.create(json: position)
    end
  end

  def self.positions(params = {})
    count_result = sliced_positions(params)

    total_count = count_result['content']['positionResult']['totalCount']
    page_size = count_result['content']['positionResult']['pageSize']

    puts "total_count = #{total_count}"

    max_page = (1.0 * total_count / page_size).ceil
    pages = (1..max_page)

    pages.each do |page|
      result = sliced_positions(params.merge(pn: page))

      result['content']['positionResult']['result'].each do |position|
        yield position
      end
    end
  end

  def self.sliced_positions(params = {})
    resp = HTTP.get(
      POSITION_URL_BASE,
      params: params
    )
    body = resp.body.to_s
    JSON.parse(body)
  end

end
