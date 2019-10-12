require 'dm-postgis'

class FundingSource
  include DataMapper::Resource
  property :name, String, :unique => true
  property :id, Integer, :key => true
  property :href, String
end
