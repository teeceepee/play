class ArticleSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :title,
    :content,
    :status,
    :published_at,
  )
end
