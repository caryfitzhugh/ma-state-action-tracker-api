require 'dm-postgis'

class ActionStatus
  include DataMapper::Resource
  property :status, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
end
