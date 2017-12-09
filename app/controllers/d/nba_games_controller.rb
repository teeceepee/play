class D::NbaGamesController < ApplicationController

  def index
    year = params[:year]
    month = params[:month]
    utc_offset = params[:utc_offset] || '+08:00'

    if year.present? && month.present?
      from = Time.new(year, month, nil, nil, nil, nil, utc_offset)
      to = from + 1.month
      nba_games = NbaGame.between_range(from, to)

      render_json(nba_games)
    else
      render_json(NbaGame.none)
    end
  end
end
