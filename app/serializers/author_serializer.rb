class AuthorSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :name,
    :bio,
    :homepage,
    :twitter,
    :facebook,
  )
end
