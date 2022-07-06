namespace :cloudlinux_ruby do
  task :validate do
    on roles(:all) do
      if fetch(:cloudlinux_ruby).nil?
        error "cloudlinux_ruby: cloudlinux_ruby is not set"
        exit 1
      end
    end
  end

  task :map_bins do
    cloudlinux_ruby_prefix = "source #{fetch(:cloudlinux_ruby)};"

    SSHKit.config.command_map[:cloudlinux_ruby_prefix] = cloudlinux_ruby_prefix

    fetch(:cloudlinux_ruby_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(cloudlinux_ruby_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'cloudlinux_ruby:validate'
  after stage, 'cloudlinux_ruby:map_bins'
end

namespace :load do
  task :defaults do
    set :cloudlinux_ruby_map_bins, %w{rake gem bundle ruby}
  end
end
