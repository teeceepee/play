class D::NbaGamesController < ApplicationController

  def index
    year = params[:year]
    month = params[:month]
    day = params[:day]
    utc_offset = params[:utc_offset] || '+08:00'

    if year.present? && month.present?
      if day.present?
        from = Time.new(year, month, day, nil, nil, nil, utc_offset)
        to = from + 1.day
      else
        from = Time.new(year, month, nil, nil, nil, nil, utc_offset)
        to = from + 1.month
      end

      nba_games = NbaGame.between_range(from, to)

      render_json(nba_games)
    else
      render_json(NbaGame.none)
    end
  end
end
