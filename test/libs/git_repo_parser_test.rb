require 'test_helper'
require 'git_repo_parser'

class GitRepoParserTest < ActiveSupport::TestCase

  def test_parse_line
    line = '12.04.5: git://github.com/tianon/docker-brew-ubuntu-core@3c355946fd5164da3f31063a5c5f249c826f7071 precise'

    parts = GitRepoParser.parse_line(line)
    assert_equal parts.size, 4
    assert_equal parts[:docker_tag], '12.04.5'

    line = 'latest: git://github.com/docker-library/wordpress@bbef6075afa043cbfe791b8de185105065c02c01'

    parts = GitRepoParser.parse_line(line)
    assert_equal parts.size, 3
    assert_equal parts[:git_commit_id], 'bbef6075afa043cbfe791b8de185105065c02c01'
  end

  def test_parse
    dir = Rails.root.join('data', 'official-images', 'library')

    assert_nothing_raised do
      repos = GitRepoParser.parse(dir)
      # repos.each do |repo|
      #   repo[:tags].each do |tag|
      #     url = GitRepoParser.dockerfile_url(tag[:git_url], tag[:git_commit_id], tag[:dockerfile_dir])
      #     if url.present?
      #       puts url
      #     else
      #       puts '=' * 100
      #       puts repo[:name]
      #       ap tag
      #     end
      #   end
      # end
    end
  end

  def test_dockerfile_url
    git_url = 'git://github.com/tianon/docker-brew-ubuntu-core'
    git_commit_id = '3c355946fd5164da3f31063a5c5f249c826f7071'
    dockerfile_dir = 'precise'
    url = GitRepoParser.dockerfile_url(git_url, git_commit_id, dockerfile_dir)

    assert_match /githubusercontent.+Dockerfile/, url
  end

end
