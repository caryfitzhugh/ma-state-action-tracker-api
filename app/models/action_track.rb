require 'ostruct'
require 'dm-postgis'

class ActionTrack
  include DataMapper::Resource
  property :id, Serial, :key => true

  # Action title: unique name
  property :title, String, :unique => true
  # Action description: unique description
  property :description, String
  # Completion Timeframe - unique - month/year -need start and end
  property :start_on, Date
  property :end_on, Date

  # Action Type - drop down
  belongs_to :action_type, ActionType, :required => false
  # Action Status - drop down
  belongs_to :action_status, ActionStatus, :required => false
  # Executive Office - drop down
  belongs_to :exec_office, ExecOffice, :required => false
  # Lead Agency - drop down
  belongs_to :lead_agency, LeadAgency, :required => false
  # Agency Priority Score - drop down
  belongs_to :agency_priority, AgencyPriority, :required => false
  # Global Action
  belongs_to :global_action, GlobalAction, :required => false

  # Progress Notes
  has n, :progress_notes, ProgressNote

  # Partner(s) - unique fill ahead
  has n, :partners, Partner, :through => :action_track_partner
  # Possible Funding Source(s) - unique - fill ahead
  has n, :funding_sources, FundingSource, :through => :action_track_funding_source
  # SHMCAP Goal(s) - drop down
  has n, :shmcap_goals, ShmcapGoal, :through => :action_track_shmcap_goal
  # Primary Climate Change Interactions - drop down
  has n, :primary_climate_interactions, PrimaryClimateInteraction, :through => :action_track_primary_climate_interaction

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
