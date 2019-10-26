require 'dm-postgis'

class ActionTrackFundingSource
  include DataMapper::Resource
  belongs_to :action_track, ActionTrack, :key => true
  belongs_to :funding_source, FundingSource, :key => true
end
