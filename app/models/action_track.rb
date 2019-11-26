require 'dm-postgis'

class ActionTrack
  include DataMapper::Resource
  include DataMapper::Audited
  is_audited
  property :id, Serial, :key => true
  property :public, Boolean, :default => false

  # Action title: unique name
  property :title, String, :unique => true, :length => 512
  # Action description: unique description
  property :description, Text

  belongs_to :completion_timeframe, CompletionTimeframe, :required => false

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

  # Action Type - drop down
  has n, :action_types, ActionType, :through => :action_track_action_type
  # Partner(s) - unique fill ahead
  has n, :partners, Partner, :through => :action_track_partner
  # Possible Funding Source(s) - unique - fill ahead
  has n, :funding_sources, FundingSource, :through => :action_track_funding_source
  # SHMCAP Goal(s) - drop down
  has n, :shmcap_goals, ShmcapGoal, :through => :action_track_shmcap_goal
  # Primary Climate Change Interactions - drop down
  has n, :primary_climate_interactions, PrimaryClimateInteraction, :through => :action_track_primary_climate_interaction

end
