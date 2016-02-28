require 'net/http'
require 'git_repo_parser'
require 'highlight'

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

  # download dockerfile and record download time
  # @return [TrueClass]
  # @return [FalseClass]
  def download_dockerfile
    content = Net::HTTP.get(URI(self.dockerfile_url))
    self.update(
      {
        dockerfile_content: content.force_encoding('utf-8'),
        dockerfile_downloaded_at: DateTime.now,
      }
    )
  end

  def buildable_url
    GitRepoParser.buildable_url(git_url, git_commit, dockerfile_dir)
  end

  # @return [String]
  # @return [NilClass]
  def highlighted_content
    if dockerfile_content.present?
      lexer = Rouge::Lexers::Dockerfile.new
      formatter = Rouge::Formatters::HTML.new
      formatter.format(lexer.lex(dockerfile_content))
    end
  end
end
