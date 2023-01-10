namespace :yarn do
  task :install do
    on roles :all do
      execute :yarn, 'install', '--production'
    end
  end
end
