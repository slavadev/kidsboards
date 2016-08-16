workers Integer(ENV['PUMA_WORKERS'] || 1)
threads_count = Integer(ENV['PUMA_MAX_THREADS'] || 16)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
environment 'production'

stdout_redirect '/home/app/logs/puma.log', '/home/app/logs/puma-error.log', true

bind "unix:///home/app/webapp/puma.sock"

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end