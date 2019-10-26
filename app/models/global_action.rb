require 'dm-postgis'

class GlobalAction
  include DataMapper::Resource
  property :action, String, :unique => true, :required => true
  property :id, Serial, :key => true
end
