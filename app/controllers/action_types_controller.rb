require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ActionTypesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['type', 'description']
    end

    type 'ActionType', {
      properties: {
        type: {type: String, description: "Name of the priority"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewActionType', {
      properties: {
        description: {type: String, description: "Tooltip info"},
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
                maximum: 5000,
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

    # GET_MANY
    endpoint description: "Get Action Type record",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        ids: ["ID of ActionType", :path, false, String]
      },
      tags: ["Action Type"]
    get "/action-types/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| ActionType.get(id)}.compact})
    end


    # GET_ONE
    endpoint description: "Get Action Type record",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        id: ["ID of ActionType", :path, true, Integer]
      },
      tags: ["Action Type"]
    get "/action-types/:id" do
      json({:data => [ActionType.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Action Type",
      responses: standard_errors( 200 => "ActionTypeResponse"),
      parameters: {
        data: ["ActionType", :body, true, 'NewActionType'],
      },
      tags: ["Action Type"]

    post "/action-types/?", require_role: :curator do
      self.create(ActionType, params['parsed_body']['data'])
    end

    # UPDATE_ONE
    endpoint description: "Update One Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        id: ["ID of ActionType", :path, true, Integer],
        data: ["ActionType", :body, true, 'ActionType'],
      },
      tags: ["Action Type"]
    put "/action-types/:id", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ActionType, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        data: ["ActionType", :body, true, ['ActionType']],
      },
      tags: ["Action Type"]
    put "/action-types/?", require_role: :curator do
      self.update_many(ActionType, params['parsed_body']['data'])
    end

    def clear_relationships(ids)
       ActionTrackActionType.all(:action_type_id => ids).each do |atat|
        atat.delete!
      end
    end

    # DELETE_ONE
    endpoint description: "Delete MANY Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        id: ["ID of ActionType", :path, true, Integer]
      },
      tags: ["Action Type"]
    delete "/action-types/:id", require_role: :curator do
      ids = [params['id']].compact
      clear_relationships(ids)
      self.delete_many(ActionType, ids)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Action Type records",
      responses: standard_errors( 200 => "ActionTypesResponse"),
      parameters: {
        ids: ["ID of ActionType", :path, false, String]
      },
      tags: ["Action Type"]
    delete "/action-types/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      clear_relationships(ids)
      self.delete_many(ActionType, params['ids'])
    end
  end
end
