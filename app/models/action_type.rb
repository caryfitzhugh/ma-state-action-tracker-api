require 'dm-postgis'

class ActionType
  include DataMapper::Resource
  property :type, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
  property :description, Text
end
