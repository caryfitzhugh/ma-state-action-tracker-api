require 'dm-postgis'

class ExecOffice
  include DataMapper::Resource
  property :name, String, :unique => true, :required => true, :length => 255
  property :id, Serial, :key => true
  property :href, Text
end
