require 'dm-postgis'

class ActionStatus
  include DataMapper::Resource
  property :status, String, :unique => true, :required => true
  property :id, Serial, :key => true
end
