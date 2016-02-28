# Docker offical images git repository parser.
module GitRepoParser

  GIT_REPO_DIR = Rails.root.join('data', 'official-images', 'library')

  def self.parse(dir = GIT_REPO_DIR)
    repos = Pathname.new(dir).children.map do |child|
      f = File.new(child)
      lines = parse_file(f)
      tags = lines.map { |line| self.parse_line(line) }
      {
        name: child.basename.to_s,
        tags: tags
      }
    end
  end

  def self.parse_file(file)
    file.each_line.to_a.reject do |line|
      # filter comment and empty lines.
      line.match(/^#|^\s*$/)
    end.map do |line|
      line.strip
    end
  end

  # 12.04.5: git://github.com/tianon/docker-brew-ubuntu-core@3c355946fd5164da3f31063a5c5f249c826f7071 precise
  # <docker-tag>: <git-url>@<git-commit-id>
  # <docker-tag>: <git-url>@<git-commit-id> <dockerfile-dir>
  # Return Hash
  # {
  #   docker_tag: '12.04.5',
  #   git_url: 'git://github.com/...',
  #   git_commit_id: '...',
  #   dockerfile_dir: 'precise'
  # }
  def self.parse_line(line)
    parts = line.split(/:? +|@/)

    if parts.size < 3
      raise "parse_line error, line: '#{line}'"
    else
      base = {
       docker_tag: parts[0],
       git_url: parts[1],
       git_commit_id: parts[2],
      }

      if parts.size == 4
        base[:dockerfile_dir] = parts[3]
      end
      base
    end
  end

  DOWNLOAD_URL_PREFIX = 'https://raw.githubusercontent.com'
  # downloadable Dockerfile url
  # 'https://raw.githubusercontent.com/tianon/docker-brew-ubuntu-core/50b3bf21537afb96d95ccb25996c7bceb16c38d8/precise/Dockerfile'
  def self.dockerfile_url(git_url, git_commit_id, dockerfile_dir = nil)
    match_data = git_url.match(/git:\/\/github.com\/(.+)\/(.+)/)
    if !match_data.nil?
      user_name = match_data[1]
      repo_name = match_data[2]

      [
        DOWNLOAD_URL_PREFIX,
        user_name,
        repo_name,
        git_commit_id,
        dockerfile_dir,
        'Dockerfile'
      ].compact.join('/')
    else
      nil
    end
  end

  # buildable url, could pass to `docker build` command
  # https://docs.docker.com/engine/reference/commandline/build/
  def self.buildable_url(git_url, git_commit_id, dockerfile_dir = nil)
    if dockerfile_dir
      "#{git_url}##{git_commit_id}:#{dockerfile_dir}"
    else
      "#{git_url}##{git_commit_id}"
    end
  end

end
