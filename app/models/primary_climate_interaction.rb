require 'dm-postgis'


class PrimaryClimateInteraction
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
end
