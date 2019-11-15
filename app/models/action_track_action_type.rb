require 'dm-postgis'

class ActionTrackActionType
  include DataMapper::Resource
  belongs_to :action_track, ActionTrack, :key => true
  belongs_to :action_type, ActionType, :key => true
end
