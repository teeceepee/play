class NbaGameSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :season_year,
    :season_type,
    :road,
    :home,
    :road_score,
    :home_score,
    :date,
    :start_time,
  )

end
