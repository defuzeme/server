namespace :db do
  task :recreate => [:drop, :create, :migrate, :seed] do
  end
end
