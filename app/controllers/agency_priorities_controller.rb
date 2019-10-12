require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class AgencyPrioritiesController < Controllers::Base
    type 'AgencyPriority', {
      properties: {
        name: {type: String, description: "Name of the priority"},
        href: {type: String, description: "Href of the priority"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'AgencyPriorityResponse', {
      properties: {
        data: {type: ["AgencyPriority"], description: "AgencyPriority records"},
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
        raise "NOT IMPLEMENTED"
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
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        AgencyPriority.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Agency Priority",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        name: ["AgencyPriority name", :body, true, String],
        href: ["AgencyPriority href", :body, true, String],
      },
      tags: ["Agency Priority"]

    post "/agency-priorities/?", require_role: :curator do
      raise "NOT IMPLEMENTED"
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
        raise "NOT IMPLEMENTED"
    end

    # UPDATE_MANY
    endpoint description: "Update Many Agency Priority records",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :body, true, [Integer]],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE
    endpoint description: "Delete Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Agency Priority records",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :query, true, [Integer]]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end
  end
end
