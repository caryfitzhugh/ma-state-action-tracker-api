require 'dm-postgis'

class ShmcapGoal
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true
  property :id, Serial, :key => true
end
