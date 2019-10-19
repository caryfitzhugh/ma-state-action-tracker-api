require './app'

namespace :db do
  task :migrate do
    DataMapper.auto_upgrade!
  end
  task :hard_migrate do
    DataMapper.auto_migrate!
  end
end
