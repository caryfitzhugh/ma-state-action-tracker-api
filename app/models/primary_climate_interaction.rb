require 'dm-postgis'


class PrimaryClimateInteraction
  include DataMapper::Resource
  property :name, String, :unique => true
  property :id, Integer, :key => true
end
