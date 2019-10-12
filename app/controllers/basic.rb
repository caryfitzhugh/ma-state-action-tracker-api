require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class MaStateActionTrackController < Controllers::Base

    # type 'ActionTrackExecOffice', {
    #   properties: {
    #     name: {type: String, description: "Name of the office"},
    #     href: {type: String, description: "Href of the office"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }
    #type 'ActionTrackLeadAgency', {
    #  properties: {
    #    name: {type: String, description: "Name of the agency"},
    #    href: {type: String, description: "Href of the agency"},
    #    id: {type: Integer, description: "ID"}
    #  }
    #}
    # type 'ActionTrackPartner', {
    #   properties: {
    #     name: {type: String, description: "Name of the partner"},
    #     href: {type: String, description: "Href of the partner"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }
    # type 'ActionTrackAgencyPriority', {
    #   properties: {
    #     name: {type: String, description: "Name of the priority"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }
    # type 'ActionTrackFundingSource', {
    #   properties: {
    #     name: {type: String, description: "Name of the funding source"},
    #     href: {type: String, description: "Href of the funding source"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }
    # type 'ActionTrackShmcapGoal', {
    #   properties: {
    #     name: {type: String, description: "Name of the goal"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }
    # type 'ActionTrackPrimaryClimateInteraction', {
    #   properties: {
    #     name: {type: String, description: "Name of the interaction"},
    #     id: {type: Integer, description: "ID"}
    #   }
    # }

    type 'ActionTrack', {
      properties: {
        :id => {type: Integer},
        :start_on => {type: String, example: "2017-01-31"},
        :end_on => {type: String, example: "2017-01-31"},

        :description => {type: String},
        :exec_office => {type: "ActionTrackExecOffice"},
        :lead_agency => {type: "ActionTrackLeadAgency"},
        :partners => {type: ["ActionTrackPartner"]},
        :agency_priority => {type: "ActionTrackAgencyPriority"},
        :funding_sources => {type: ["ActionTrackFundingSource"]},
        :shmcap_goals => {type: ["ActionTrackShmcapGoal"]},
        :primary_climate_interactions => {type: ["ActionTrackPrimaryClimateInteraction"]}
      }
    }

    type 'MAStateActionTrackSearchResponse', {
      properties: {
        total: { type: Integer, description: "Total number of records"},
        page: { type: Integer, description: "Page of results being returned"},
        per_page: { type: Integer, description: "Number of results being returned"},
        results: { type: ["ActionTrack"], description: "Results"},
      }
    }

    endpoint description: "Search for action tracks",
              responses: standard_errors( 200 => "MAStateActionTrackSearchResponse"),
              parameters: {
                "page": ["Page of records to return", :query, false, Integer, :minimum => 1],
                "per_page": ["Number of records to return", :query, false, Integer, {:minimum => 1, :maximum => 100}],
                "start_on_before": ["Limit to resources start_on dates to <= this date", :query, false, String, :format => :date],
                "start_on_after": ["Limit to resources start_on dates to >= this date", :query, false, String, :format => :date],
                "end_on_before": ["Limit to resources end_on dates to <= this date", :query, false, String, :format => :date],
                "end_on_after": ["Limit to resources end_on dates to >= this date", :query, false, String, :format => :date],
                "title_like": ["Search for titles similar to this", :query, false, String],
                "description_like": ["Search for descriptions similar to this", :query, false, String],
                "query": ["Search text across all text or field names", :query, false, String],
                "executive_offices": ["Id of executive offices to search against (comma separated)", :query, false, String],
                "lead_agencies": ["Id of lead agencies to search against (comma separated)", :query, false, String],
                "partners": ["Id of partners to search against (comma separated)", :query, false, String],
                "agency_priorities": ["Id of agency priorities to search against (comma separated)", :query, false, String],
                "funding_sources": ["Id of funding sources to search against (comma separated)", :query, false, String],
                "shmcap_goals": ["Id of shmcap goals to search against (comma separated)", :query, false, String],
                "primary_climate_interactions": ["Id of primary climate interactions to search against (comma separated)", :query, false, String],

              },
              tags: ["MA", "MA::StateActionTracker", "Public"]

    get "/ma/state_action_tracks/?" do
      cross_origin
      params[:per_page] = (params[:per_page] ||= 50).to_i
      params[:page] = (params[:page] ||= 1).to_i

      results = MA::StateActionTracker::ActionTrack.search(
        page: (params[:page] || 50).to_i,
        per_page: (params[:per_page] || 50).to_i,
        start_on_range: [params[:start_on_after], params[:start_on_before]],
        end_on_range: [params[:end_on_after], params[:end_on_before]],
        title_like: params[:title_like],
        description_like: params[:description_like] || [],
        executive_offices: params[:executive_offices] || [],
        lead_agencies: params[:lead_agencies] || [],
        partners: params[:partners] || [],
        agency_priorities: params[:agency_priorities] || [],
        funding_sources: params[:funding_sources] || [],
        shmcap_goals: params[:shmcap_goals] || [],
        primary_climate_interactions: params[:primary_climate_interactions] || []
      )

      json({
        total: results.total,
        page: params[:page].to_i,
        per_page: params[:per_page].to_i,
        results: results.results
      })
    end
  end
end
