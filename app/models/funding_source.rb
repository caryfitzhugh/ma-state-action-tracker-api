require 'dm-postgis'

class FundingSource
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
  property :href, Text
  property :description, Text
end
