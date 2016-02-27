require 'net/http'
require 'git_repo_parser'

class Tag < ApplicationRecord
  belongs_to :repo

  def dockerfile_url
    GitRepoParser.dockerfile_url(git_url, git_commit, dockerfile_dir)
  end

  def download_dockerfile
    content = Net::HTTP.get(URI(self.dockerfile_url))
    self.update(dockerfile_content: content.force_encoding('utf-8'))
    content
  end
end
