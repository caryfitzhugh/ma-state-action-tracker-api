require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ActionTypesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['type']
    end

    type 'ActionType', {
      properties: {
        type: {type: String, description: "Name of the priority"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewActionType', {
      properties: {
        type: {type: String, description: "Name of the priority"}
      }
    }

    type 'ActionTypesResponse', {
      properties: {
        data: {type: ["ActionType"], description: "ActionType records"},
      }
    }

    type 'ActionTypeResponse', {
      properties: {
        data: {type: "ActionType", description: "ActionType records"},
      }
    }

    type 'ActionTypeIndexResponse', {
      properties: {
        data: {type: ["ActionType"], description: "ActionType records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Action Type records",
      responses: standard_errors( 200 => "ActionTypeIndexResponse"),
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
      tags: ["Action Type"]
    get "/action-types/?" do
      self.get_list(ActionType, params)
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Action Type record",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        ids: ["ID of ActionType", :path, true, [Integer]]
      },
      tags: ["Action Type"]
    get "/action-types/:ids" do
      self.get_one_or_many(ActionType, params)
    end

    # CREATE
    endpoint description: "Create Action Type",
      responses: standard_errors( 200 => "ActionTypeResponse"),
      parameters: {
        action_type: ["ActionType", :body, true, 'NewActionType'],
      },
      tags: ["Action Type"]

    post "/action-types/?", require_role: :curator do
      self.create(ActionType, params['parsed_body']['action_type'])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        action_types: ["ActionType", :body, true, ['ActionType']],
      },
      tags: ["Action Type"]
    put "/action-types/?", require_role: :curator do
      self.update_many(ActionType, params['parsed_body']['action_types'])
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        ids: ["ID of ActionType", :query, true, [Integer]]
      },
      tags: ["Action Type"]
    delete "/action-types/?", require_role: :curator do
      self.delete_many(ActionType, params)
    end
  end
end
