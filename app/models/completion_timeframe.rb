require 'dm-postgis'

class CompletionTimeframe
  include DataMapper::Resource
  property :timeframe, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
  property :description, Text
end
