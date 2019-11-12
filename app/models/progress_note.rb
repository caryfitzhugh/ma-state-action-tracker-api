require 'dm-postgis'

class ProgressNote
  include DataMapper::Resource
  property :note, Text, :required => true
  property :created_on, DateTime, :default => "NOW()"
  property :id, Serial, :key => true
  belongs_to :action_track, ActionTrack
end
