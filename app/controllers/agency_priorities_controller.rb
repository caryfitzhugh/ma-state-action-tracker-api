require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class AgencyPrioritiesController < Controllers::Base
    EDITABLE_FIELDS = ['name']

    type 'AgencyPriority', {
      properties: {
        name: {type: String, description: "Name of the priority"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'AgencyPrioritiesResponse', {
      properties: {
        data: {type: ["AgencyPriority"], description: "AgencyPriority records"},
      }
    }

    type 'AgencyPriorityResponse', {
      properties: {
        data: {type: "AgencyPriority", description: "AgencyPriority records"},
      }
    }

    type 'AgencyPriorityIndexResponse', {
      properties: {
        data: {type: ["AgencyPriority"], description: "AgencyPriority records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Agency Priority records",
      responses: standard_errors( 200 => "AgencyPriorityIndexResponse"),
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
      tags: ["Agency Priority"]
    get "/agency-priorities/?" do
      self.get_list(AgencyPriority, params)
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :path, true, [Integer]]
      },
      tags: ["Agency Priority"]
    get "/agency-priorities/:ids" do
      self.get_one_or_many(AgencyPriority, params)
    end

    # CREATE
    endpoint description: "Create Agency Priority",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        name: ["AgencyPriority name", :body, true, String],
      },
      tags: ["Agency Priority"]

    post "/agency-priorities/?", require_role: :curator do
      self.create(AgencyPriority, params)
    end

    # UPDATE
    endpoint description: "Update Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/:id/?", require_role: :curator do
      self.update_one(AgencyPriority, params)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :body, true, [Integer]],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/?", require_role: :curator do
      self.update_many(AgencyPriority, params)
    end

    # DELETE
    endpoint description: "Delete Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/:id/?", require_role: :curator do
      self.delete_record(AgencyPriority, params)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :query, true, [Integer]]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/?", require_role: :curator do
      self.delete_many(AgencyPriority, params)
    end
  end
end
