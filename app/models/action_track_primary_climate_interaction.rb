require 'dm-postgis'

class ActionTrackPrimaryClimateInteraction
  include DataMapper::Resource
  belongs_to :action_track, ActionTrack, :key => true
  belongs_to :primary_climate_interaction, PrimaryClimateInteraction, :key => true
end
