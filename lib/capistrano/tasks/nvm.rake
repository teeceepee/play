# https://github.com/koenpunt/capistrano-nvm
namespace :nvm do
  task :validate do
    on release_roles(fetch(:nvm_roles)) do
      nvm_node = fetch(:nvm_node)
      if nvm_node.nil?
        error "nvm: nvm_node is not set"
        exit 1
      end

      unless test "[ -d #{fetch(:nvm_node_dir)} ]"
        error "nvm: #{nvm_node} is not installed or not found in #{fetch(:nvm_node_dir)}"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!({ node_version: "#{fetch(:nvm_node)}" })
    nvm_prefix = fetch(:nvm_prefix, -> { "source #{fetch(:nvm_path)}/nvm.sh; nvm exec --silent #{fetch(:nvm_node)}" })
    SSHKit.config.command_map[:nvm] = "source #{fetch(:nvm_path)}/nvm.sh; nvm"

    fetch(:nvm_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(nvm_prefix)
    end
  end
end

unless ENV['PROVISION']
  Capistrano::DSL.stages.each do |stage|
    after stage, 'nvm:validate'
    after stage, 'nvm:map_bins'
  end
end

namespace :load do
  task :defaults do

    set :nvm_path, -> {
      nvm_path = fetch(:nvm_custom_path)
      nvm_path ||= if fetch(:nvm_type, :user) == :system
        "/usr/local/nvm"
      else
        "$HOME/.nvm"
      end
    }

    set :nvm_roles, fetch(:nvm_roles, :all)
    set :nvm_node_dir, -> { "#{fetch(:nvm_path)}/versions/node/#{fetch(:nvm_node)}" }
    set :nvm_map_bins, %w{node npm}
  end
end
