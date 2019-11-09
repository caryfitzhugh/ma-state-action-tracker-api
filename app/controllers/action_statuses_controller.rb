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

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Action Status record",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        ids: ["ID of ActionStatus", :path, true, [Integer]]
      },
      tags: ["Action Status"]
    get "/action-statuses/:ids" do
      self.get_one_or_many(ActionStatus, params)
    end

    # CREATE
    endpoint description: "Create Action Status",
      responses: standard_errors( 200 => "ActionStatusResponse"),
      parameters: {
        action_status: ["ActionStatus", :body, true, 'NewActionStatus'],
      },
      tags: ["Action Status"]

    post "/action-statuses/?", require_role: :curator do
      self.create(ActionStatus, params['parsed_body']['action_status'])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        action_statuses: ["ActionStatus", :body, true, ['ActionStatus']],
      },
      tags: ["Action Status"]
    put "/action-statuses/?", require_role: :curator do
      self.update_many(ActionStatus, params['parsed_body']['action_statuses'])
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Action Status records",
      responses: standard_errors( 200 => "ActionStatusesResponse"),
      parameters: {
        ids: ["ID of ActionStatus", :query, true, [Integer]]
      },
      tags: ["Action Status"]
    delete "/action-statuses/?", require_role: :curator do
      self.delete_many(ActionStatus, params)
    end
  end
end
