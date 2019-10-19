require 'dm-postgis'

class LeadAgency
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true
  property :id, Serial, :key => true
  property :href, String
end
