require 'dm-postgis'

class AgencyPriority
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
  property :description, Text
end
