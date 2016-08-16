# Set unicorn options
worker_processes (ENV['MAX_WORKERS'] || 1).to_i
preload_app true
timeout 30

# Set up socket location
listen "/home/app/webapp/unicorn.sock", :backlog => 256

# Logging
stderr_path "/home/app/logs/unicorn.stderr.log"
stdout_path "/home/app/logs/unicorn.stdout.log"

# Set master PID location
pid "/home/app/webapp/unicorn.pid"