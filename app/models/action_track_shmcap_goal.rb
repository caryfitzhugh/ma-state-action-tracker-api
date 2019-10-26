require 'dm-postgis'

class ActionTrackShmcapGoal
  include DataMapper::Resource
  belongs_to :action_track, ActionTrack, :key => true
  belongs_to :shmcap_goal, ShmcapGoal, :key => true
end
