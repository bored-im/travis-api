# https://michael.vanrooijen.io/parallelism-on-heroku/

worker_processes Integer(ENV.fetch('WEB_CONCURRENCY')) # amount of unicorn workers to spin up
timeout 30 # restarts workers that hang for 30 seconds

tmp_dir = ENV.fetch("tmp_dir", "/tmp")

# If we're running on Heroku, use a unix socket for the nginx buildpack
# In Enterprise we still use ports for now
if ENV['DYNO']
  listen File.expand_path("nginx.socket", tmp_dir), backlog: 1024
else
  listen "#{Integer(ENV.fetch('PORT'))}", backlog: 1024
end

logger Logger.new($stdout)

require 'fileutils'
before_fork do |server, worker|
  # preload travis so we can have copy on write
  $: << 'lib'
  require 'nakayoshi_fork'
  require 'travis/api/app'
end
