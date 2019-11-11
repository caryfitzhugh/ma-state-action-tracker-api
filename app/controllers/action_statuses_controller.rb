require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ActionStatusesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['status']
    end

    type 'ActionStatus', {
      properties: {
        status: {type: String, description: "Name of the status"},
        id: {type: Integer, description: "ID"}
      }
    }
    type 'NewActionStatus', {
      properties: {
        status: {type: String, description: "Name of the status"},
      }
    }
    type 'ActionStatusesResponse', {
      properties: {
        data: {type: ["ActionStatus"], description: "ActionStatus records"},
      }
    }

    type 'ActionStatusResponse', {
      properties: {
        data: {type: "ActionStatus", description: "ActionStatus records"},
      }
    }

    type 'ActionStatusIndexResponse', {
      properties: {
        data: {type: ["ActionStatus"], description: "ActionStatus records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Action Status records",
      responses: standard_errors( 200 => "ActionStatusIndexResponse"),
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
      tags: ["Action Status"]
    get "/action-statuses/?" do
      self.get_list(ActionStatus, params)
    end

    # GET_MANY
    endpoint description: "Get Action Status record",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        ids: ["ID of ActionStatus", :path, false, [Integer]]
      },
      tags: ["Action Status"]
    get "/action-statuses/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| ActionStatus.get!(id)}})
    end

    # GET_ONE
    endpoint description: "Get Action Status record",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        id: ["ID of ActionStatus", :path, true, Integer]
      },
      tags: ["Action Status"]
    get "/action-statuses/:id" do
      json({:data => [ActionStatus.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Action Status",
      responses: standard_errors( 200 => "ActionStatusResponse"),
      parameters: {
        data: ["ActionStatus", :body, true, 'NewActionStatus'],
      },
      tags: ["Action Status"]
    post "/action-statuses/?", require_role: :curator do
      self.create(ActionStatus, params['parsed_body']['data'])
    end

    # UPDATE_ONE
    endpoint description: "Update one Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        id: ["ID of ActionStatus", :path, true, Integer],
        data: ["ActionStatus", :body, true, 'ActionStatus'],
      },
      tags: ["Action Status"]
    put "/action-statuses/:id?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ActionStatus, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        data: ["ActionStatus", :body, true, ['ActionStatus']],
      },
      tags: ["Action Status"]
    put "/action-statuses/?", require_role: :curator do
      self.update_many(ActionStatus, params['parsed_body']['data'])
    end

    # DELETE_ONE
    endpoint description: "Delete One Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        id: ["ID of ActionStatus", :path, true, Integer]
      },
      tags: ["Action Status"]
    delete "/action-types/:id", require_role: :curator do
      self.delete_many(ActionStatus, [params['id']].compact)
    end
    # DELETE_MANY
    endpoint description: "Delete MANY Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        ids: ["ID of ActionStatus", :path, false, String]
      },
      tags: ["Action Status"]
    delete "/action-statuses/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(ActionStatus, ids)
    end
  end
end
