require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class GlobalActionsController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['action']
    end

    type 'GlobalAction', {
      properties: {
        action: {type: String, description: "Name of the priority"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'GlobalActionsResponse', {
      properties: {
        data: {type: ["GlobalAction"], description: "GlobalAction records"},
      }
    }

    type 'GlobalActionResponse', {
      properties: {
        data: {type: "GlobalAction", description: "GlobalAction records"},
      }
    }

    type 'GlobalActionIndexResponse', {
      properties: {
        data: {type: ["GlobalAction"], description: "GlobalAction records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Global Action records",
      responses: standard_errors( 200 => "GlobalActionIndexResponse"),
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
      tags: ["Global Action"]
    get "/global-actions/?" do
      self.get_list(GlobalAction, params)
    end

    # GET_MANY
    endpoint description: "Get Global Action record",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        ids: ["ID of GlobalAction", :path, false, String]
      },
      tags: ["Global Action"]
    get "/global-actions/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| GlobalAction.get!(id)}})
    end


    # GET_ONE
    endpoint description: "Get Global Action record",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        id: ["ID of GlobalAction", :path, true, Integer]
      },
      tags: ["Global Action"]
    get "/action-statuses/:id" do
      json({:data => [GlobalAction.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Global Action",
      responses: standard_errors( 200 => "GlobalActionResponse"),
      parameters: {
        data: ["GlobalAction", :body, true, 'NewActionStatus'],
      },
      tags: ["Global Action"]

    post "/global-actions/?", require_role: :curator do
      self.create(GlobalAction, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Global Action record",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        id: ["ID of GlobalAction", :path, true, Integer],
        data: ["Data of GlobalAction", :body, true, "GlobalAction"]
      },
      tags: ["Global Action"]
    put "/global-actions/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(GlobalAction, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Global Action records",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        data: ["Data of GlobalAction", :body, true, ["GlobalAction"]]
      },
      tags: ["Global Action"]
    put "/global-actions/?", require_role: :curator do
      self.update_many(GlobalAction, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete Global Action record",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        id: ["ID of GlobalAction", :path, true, Integer]
      },
      tags: ["Global Action"]
    delete "/global-actions/:id/?", require_role: :curator do
      self.delete_many(GlobalAction, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Global Action records",
      responses: standard_errors( 200 => "GlobalActionsResponse"),
      parameters: {
        ids: ["ID of GlobalAction", :path, false, String]
      },
      tags: ["Global Action"]
    delete "/global-actions/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(GlobalAction, ids)
    end
  end
end
