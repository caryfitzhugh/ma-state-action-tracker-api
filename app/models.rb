require 'data_mapper'
require 'dm-postgres-types'
require 'dm-postgis'
require 'dm-chunked_query'
require 'dm-timestamps'

require 'lib/config'

require 'app/models/agency_priority'
require 'app/models/exec_office'
require 'app/models/funding_source'
require 'app/models/lead_agency'
require 'app/models/partner'

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
