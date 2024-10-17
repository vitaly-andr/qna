lock "~> 3.19.1"
set :bundle_flags, ''

set :application, 'qna'
set :repo_url, 'git@github.com:vitaly-andr/qna.git'

set :deploy_to, '/home/deployer/qna'

set :branch, 'main'

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.3.4'

append :linked_files, 'config/database.yml', 'config/credentials/production.key', '.env' , 'config//credentials/production.yml.enc'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads', 'storage'

set :puma_threads, [4, 16]
set :puma_workers, 2
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, 60
set :puma_init_active_record, true

set :sidekiq_roles, :app
set :sidekiq_processes, 2

# set :format_options, log_file: "#{shared_path}/log/capistrano.log"
