require 'dm-postgis'

class ActionTrackPartner
  include DataMapper::Resource
  belongs_to :action_track, ActionTrack, :key => true
  belongs_to :partner, Partner, :key => true
end
