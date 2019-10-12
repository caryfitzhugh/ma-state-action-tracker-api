require 'dm-postgis'

class AgencyPriority
  include DataMapper::Resource
  property :name, String, :unique => true
  property :id, Integer, :key => true
end
