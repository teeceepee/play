require 'git_repo_parser'

class Repo < ApplicationRecord

  ## Associations
  has_many :tags

  ## Validations
  validates :name, presence: true, length: {maximum: 100}
  validates :tag_count, numericality: {greater_than_or_equal_to: 0}

  def self.import_from_git_repo
    git_repo_dir = Rails.root.join('data', 'official-images', 'library')
    repos_array = GitRepoParser.parse

    repos_array.each do |repo_hash|
      repo = self.find_or_create_by(name: repo_hash[:name])


      if repo.present?
        repo_hash[:tags].each do |tag_hash|
          attrs = {
            name: tag_hash[:docker_tag],
            git_url: tag_hash[:git_url],
            git_commit: tag_hash[:git_commit_id],
            dockerfile_dir: tag_hash[:dockerfile_dir]
          }
          repo.tags.find_or_create_by(attrs)
        end

      end

    end
  end

  def to_s
    name
  end
end
