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

    type 'NewActionTrack', {
      properties: {
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

    type 'ActionTracksResponse', {
      properties: {
        data: {type: ["ActionTrack"], description: "ActionTrack records"},
      }
    }

    type 'ActionTrackResponse', {
      properties: {
        data: {type: "ActionTrack", description: "ActionTrack records"},
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
      self.get_list(ActionTrack, params)
    end

    # GET_MANY
    endpoint description: "Get ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :query, true, [Integer]]
      },
      tags: ["ActionTrack"]
    get "/action-tracks/get-many/?" do
      self.get_one_or_many(ActionTrack, params['ids'])
    end


    # GET_ONE
    endpoint description: "Get ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer]
      },
      tags: ["ActionTrack"]
    get "/action-statuses/:id" do
      self.get_one_or_many(ActionTrack, [params["id"]])
    end

    # CREATE
    endpoint description: "Create ActionTrack",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        data: ["ActionTrack", :body, true, "NewActionTrack"]
      },
      tags: ["ActionTrack"]

    post "/action-tracks/?", require_role: :curator do
      # require 'pry'; binding.pry
      self.create(ActionTrack, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer],
        data: ["Data of ActionTrack", :body, true, "ActionTrack"]
      },
      tags: ["ActionTrack"]
    put "/action-tracks/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ActionTrack, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many ActionTrack records",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        data: ["Data of ActionTracks", :body, true, ["ActionTrack"]]
      },
      tags: ["ActionTrack"]
    put "/action-tracks/?", require_role: :curator do
        self.update_many(ActionTrack, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer]
      },
      tags: ["ActionTrack"]
    delete "/action-tracks/:id/?", require_role: :curator do
      self.delete_many(ActionTrack, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY ActionTrack records",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :query, true, [Integer]]
      },
      tags: ["ActionTrack"]
    delete "/action-tracks/?", require_role: :curator do
      self.delete_many(ActionTrack, params['ids'])
    end
  end
end
