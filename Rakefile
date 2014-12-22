require 'rake'
require 'bundler'
require 'rubygems'

Bundler.setup(:default, :test)

begin
  require 'rspec/core/rake_task'
rescue LoadError
end

desc 'Build and install into gem environment'
task 'install' do
  Rake::Task["bundler:install"].invoke
  gem_helper.install_gem
end

if defined?(RSpec)
  namespace :spec do
    desc 'Run Unit Tests'
    rspec_task = RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/**/*_spec.rb"
      t.rspec_opts = %w(--format progress --colour)
    end
  end

  desc "Run tests"
  task :spec => %w(spec:unit)
  task :default => :spec
end
