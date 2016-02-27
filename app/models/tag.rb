require 'net/http'
require 'git_repo_parser'

class Tag < ApplicationRecord

  ## Associations
  belongs_to :repo

  ## Validations
  validates :repo, presence: true
  validates :name, presence: true, length: {maximum: 100}
  validates :git_url, presence: true, length: {maximum: 250}
  validates :git_commit, presence: true, length: {is: 40}

  def dockerfile_url
    GitRepoParser.dockerfile_url(git_url, git_commit, dockerfile_dir)
  end

  def download_dockerfile
    content = Net::HTTP.get(URI(self.dockerfile_url))
    self.update(dockerfile_content: content.force_encoding('utf-8'))
    content
  end
end
