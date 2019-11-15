require 'data_mapper'
require 'dm-postgres-types'
require 'dm-postgis'
require 'dm-chunked_query'
require 'dm-timestamps'
require 'dm-serializer'
require 'dm-pager'

require 'lib/config'
require 'app/models/user'

require 'app/models/agency_priority'
require 'app/models/action_status'
require 'app/models/action_type'
require 'app/models/exec_office'
require 'app/models/global_action'
require 'app/models/funding_source'
require 'app/models/lead_agency'
require 'app/models/partner'
require 'app/models/primary_climate_interaction'
require 'app/models/shmcap_goal'

class ActionTrack
end
# Requires ActionTrack
require 'app/models/progress_note'

require 'app/models/action_track_action_type'
require 'app/models/action_track_funding_source'
require 'app/models/action_track_partner'
require 'app/models/action_track_primary_climate_interaction'
require 'app/models/action_track_shmcap_goal'

require 'app/models/action_track'

DataMapper.finalize
DataMapper::Logger.new($stdout, :info)
if CONFIG.postgres
  connected = false
  while !connected
    begin
      DataMapper.setup(:default, CONFIG.postgres.to_h)
      connected = true
    rescue DataObjects::ConnectionError
      connected = false
      sleep 1
    end
  end
else
  raise "Need to have POSTGRES_DB_URL set!"
end
