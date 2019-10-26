require 'dm-postgis'

class ActionType
  include DataMapper::Resource
  property :type, String, :unique => true, :required => true
  property :id, Serial, :key => true
end
