json.array!(@tags) do |tag|
  json.extract! tag, :id, :repo_id, :name, :git_url, :git_commit, :dockerfile_dir
  json.url tag_url(tag, format: :json)
end
