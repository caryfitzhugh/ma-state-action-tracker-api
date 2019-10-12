require 'dm-postgis'

class ShmcapGoal
  include DataMapper::Resource
  property :name, String, :unique => true
  property :id, Integer, :key => true
end
