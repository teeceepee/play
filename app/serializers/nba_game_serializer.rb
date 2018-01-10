class NbaGameSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :season_year,
    :season_type,
    :road,
    :road_text,
    :road_logo,
    :home,
    :home_text,
    :home_logo,
    :road_score,
    :home_score,
    :date,
    :start_time,
  )

end
