class NbaGame < ApplicationRecord

  TEAMS = %w(
    atl
    bkn
    bos
    cha
    chi
    cle
    dal
    den
    det
    gsw
    hou
    ind
    lac
    lal
    mem
    mia
    mil
    min
    nop
    nyk
    okc
    orl
    phi
    phx
    por
    sac
    sas
    tor
    uta
    was
  )

  # validations
  validates_presence_of :date, :road, :home
  validates_uniqueness_of :date, scope: [:road, :home]

  # enums
  enumerize :season_type, in: [
    :preseason,
    :regular,
    :playoff,
  ], scope: true

  enumerize :road, in: TEAMS + ['other']
  enumerize :home, in: TEAMS + ['other']


  def road_logo
    self.class.team_logo(self.road)
  end

  def home_logo
    self.class.team_logo(self.home)
  end

  def self.team_logo(team)
    if TEAMS.include?(team)
      host = Rails.configuration.action_controller.asset_host
      ActionController::Base.helpers.asset_pack_path("team_logos/#{team}.png", host: host)
    end
  end

  def self.between_range(from, to)
    self.where('start_time >= ? AND start_time < ?', from, to)
  end

  def self.fetch_schedule(season_year = '2017')
    resp = HTTP.get(season_url(season_year))

    data = JSON.parse(resp)
    games = data['lscd'].map do |month|
      month['mscd']['g']
    end.flatten

    opener_date = Date.new(2017, 10, 17)

    games.each do |game|
      start_time = Time.parse("#{game['gdtutc']} #{game['utctm']} Z")
      date = Date.strptime(game['gdte'], '%F')

      season_type = if date >= opener_date
        :regular
      else
        :preseason
      end

      code = game['gcode']

      teams = code.split('/').last
      road = normalize_team_name(teams[0...3])
      home = normalize_team_name(teams[3...6])

      road_score, home_score = nil, nil

      if game['stt'] == 'Final'
        road_score = game['v']['s'].presence
        home_score = game['h']['s'].presence
      end

      attrs = {
        season_year: season_year,
        season_type: season_type,
        start_time: start_time,
        date: date,
        road: road,
        home: home,
        road_score: road_score,
        home_score: home_score,
      }

      g = self.find_by(date: date, road: road, home: home)

      if g.present?
        g.update(attrs)
      else
        self.create(attrs)
      end
    end

    nil
  end

  def self.season_url(season_year)
    "http://data.nba.com/data/10s/v2015/json/mobile_teams/nba/#{season_year}/league/00_full_schedule.json"
  end

  def self.normalize_team_name(name)
    n = name.downcase
    TEAMS.include?(n) ? n : 'other'
  end

end
