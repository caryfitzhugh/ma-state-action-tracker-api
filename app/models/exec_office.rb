require 'dm-postgis'

class ExecOffice
  include DataMapper::Resource
  property :name, String, :unique => true
  property :id, Integer, :key => true
  property :href, String
end
