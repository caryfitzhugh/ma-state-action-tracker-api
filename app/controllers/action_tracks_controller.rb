require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ActionTracksController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["start_on",
       "end_on",
       "description",
       "exec_office",
       "lead_agency",
       "partners",
       "agency_priority",
       "funding_sources",
       "shmcap_goals",
       "primary_climate_interactions",
       "global_action"
      ]
    end

    type 'ActionTrack', {
      properties: {
        :id => {type: Integer},
        :start_on => {type: String, example: "2017-01-31"},
        :end_on => {type: String, example: "2017-01-31"},

        :description => {type: String},
        :exec_office => {type: "ExecOffice"},
        :lead_agency => {type: "LeadAgency"},
        :partners => {type: ["Partner"]},
        :agency_priority => {type: "AgencyPriority"},
        :funding_sources => {type: ["FundingSource"]},
        :shmcap_goals => {type: ["ShmcapGoal"]},
        :primary_climate_interactions => {type: ["PrimaryClimateInteraction"]}
      }
    }

    type 'ActionTrackResponse', {
      properties: {
        data: {type: ["ActionTrack"], description: "ActionTrack records"},
      }
    }

    type 'ActionTrackIndexResponse', {
      properties: {
        data: {type: ["ActionTrack"], description: "ActionTrack records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Action Track records",
      responses: standard_errors( 200 => "ActionTrackIndexResponse"),
      parameters: {
        page: ["Page Start", :query, false, Integer, {
                minimum: 1,
                default: 1,
                example: 1
              }],
        per_page: ["Records per page", :query, false, Integer, {
                minimum: 1,
                default: 20,
                maximum: 50,
                example: 10
              }],
        sort_by_field: ["Field to sort on", :query, false, String],
        sort_by_order: ["Field sort direction (ASC/DESC)", :query, false, String],
        filter: ["Filter to sort on {field_name: value}", :query, false, String],
      },
      tags: ["Action Track"]
    get "/action-tracks/?" do
        raise "NOT IMPLEMENTED"
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Action Track record",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :path, true, [Integer]]
      },
      tags: ["Action Track"]
    get "/action-tracks/:ids" do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        ActionTrack.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Action Track",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        name: ["ActionTrack name", :body, true, String],
        start_on: ["start on", :body, false, DateTime],
        end_on:   ["end on", :body, false, DateTime],
        description: ["Description", :body, false, String],
        exec_office: ["Exec Office id", :body, false, Integer],
        lead_agency: ["Lead Agency ID", :body, false, Integer],
        partners: ["Partner IDs", :body, false, [Integer]],
        agency_priority: ["Priority IDs", :body, false, [Integer]],
        funding_sources: ["Funding Source IDs", :body, false, [Integer]],
        shmcap_goals: ["Shmcap Goal IDs", :body, false, [Integer]],
        primary_climate_interactions: ["Climate Interaction IDs", :body, false, [Integer]],
      },
      tags: ["Action Track"]

    post "/action-tracks/?", require_role: :curator do
      raise "NOT IMPLEMENTED"
    end

    # UPDATE
    endpoint description: "Update Action Track record",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer],
        data: ["Data of ActionTrack", :body, true, "ActionTrack"]
      },
      tags: ["Action Track"]
    put "/action-tracks/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # UPDATE_MANY
    endpoint description: "Update Many Action Track records",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :body, true, [Integer]],
        data: ["Data of ActionTrack", :body, true, "ActionTrack"]
      },
      tags: ["Action Track"]
    put "/action-tracks/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE
    endpoint description: "Delete Action Track record",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer]
      },
      tags: ["Action Track"]
    delete "/action-tracks/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Action Track records",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :query, true, [Integer]]
      },
      tags: ["Action Track"]
    delete "/action-tracks/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end
  end
end
