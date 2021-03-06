require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class AgencyPrioritiesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['name', 'description']
    end

    type 'AgencyPriority', {
      properties: {
        name: {type: String, description: "Name of the priority"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewAgencyPriority', {
      properties: {
        name: {type: String, description: "Name of the priority"},
        description: {type: String, description: "Tooltip info"}
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
                maximum: 5000,
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

    # GET_MANY
    endpoint description: "Get Agency Priority record",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :path, false, String]
      },
      tags: ["Agency Priority"]
    get "/agency-priorities/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| AgencyPriority.get(id)}.compact})
    end

    # GET_ONE
    endpoint description: "Get Agency Priority record",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer]
      },
      tags: ["Agency Priority"]
    get "/agency-priorities/:id" do
      json({:data => [AgencyPriority.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Agency Priority",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        data: ["AgencyPriority", :body, true, 'NewAgencyPriority'],
      },
      tags: ["Agency Priority"]

    post "/agency-priorities/?", require_role: :curator do
      self.create(AgencyPriority, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Agency Priority record",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(AgencyPriority, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        data: ["Data of AgencyPriority", :body, true, ["AgencyPriority"]]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/?", require_role: :curator do
      self.update_many(AgencyPriority, params['parsed_body']['data'])
    end

    def clear_relationships(ids)
      ActionTrack.all(:agency_priority_id => ids).each do |at|
        at.agency_priority_id = nil
        at.save!
      end
    end

    # DELETE
    endpoint description: "Delete Agency Priority record",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/:id/?", require_role: :curator do
      ids = [params['id']].compact
      clear_relationships(ids)
      self.delete_many(AgencyPriority, ids)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :path, false, String]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      clear_relationships(ids)
      self.delete_many(AgencyPriority, ids)
    end
  end
end
