require 'ostruct'
require 'dm-postgis'

class ActionTrack
  include DataMapper::Resource
  property :id, Serial

  # Action title: unique name
  property :title, String, :unique => true
  # Action description: unique description
  property :description, String
  # Executive Office - drop down
  has 1, :action_track_exec_office, ExecOffice
  # Lead Agency - drop down
  has 1, :action_track_lead_agency, LeadAgency
  # Partner(s) - unique fill ahead
  has n, :action_track_partner, Partner
  # Agency Priority Score - drop down
  has 1, :action_track_agency_priority, AgencyPriority
  # Possible Funding Source(s) - unique - fill ahead
  has n, :action_track_funding_source, FundingSource
  # SHMCAP Goal(s) - drop down
  has n, :action_track_shmcap_goal, ShmcapGoal
  # Primary Climate Change Interactions - drop down
  has n, :action_track_primary_climate_interaction, PrimaryClimateInteraction

  # Completion Timeframe - unique - month/year -need start and end
  property :start_on, Date
  property :end_on, Date

  # Hazards - TBD
  # has n, :action_track_hazard
  # Sectors - TBD
  # has n, :action_track_sector
  # Actions - TBD
  # has n, :action_track_action
  # Benefits - TBD
  # has n, :action_track_benefit
  validates_primitive_type_of :start_on, :end_on

  def self.search(
             page: 1,
             per_page: 50,
             start_on_range: [],
             end_on_range: [],
             title_like: nil,
             description_like: nil,
             executive_offices: [],
             lead_agencies: [],
             partners: [],
             agency_priorities: [],
             funding_sources: [],
             shmcap_goals: [],
             primary_climate_interactions: [])

    # require 'pry'
    # binding.pry

    # results = self.all(:limit => per_page, :offset => per_page * (page - 1))
    # if start_on_range[0] && start_on_range[1]
    #     results = results.all(:start_on => start_on_range[0] .. start_on_range[1])
    # else if start_on_range[0]
    #     results = results.all(:start_on.gt => start_on_range[0])
    # else if start_on_range[1]
    #     results = results.all(:start_on.lt => start_on_range[1])
    # end

    # if end_on_range[0] && end_on_range[1]
    #     results = results.all(:end_on => end_on_range[0] .. end_on_range[1])
    # else if end_on_range[0]
    #     results = results.all(:end_on.gt => end_on_range[0])
    # else if end_on_range[1]
    #     results = results.all(:end_on.lt => end_on_range[1])
    # end



    total_count = results.count


    OpenStruct.new({
      :results => results,
      :total => total_count
    })
  end
end
