require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ShmcapGoalsController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["name", 'description']
    end

    type 'ShmcapGoal', {
      properties: {
        name: {type: String, description: "Name of the goal"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewShmcapGoal', {
      properties: {
        name: {type: String, description: "Name of the goal"},
        description: {type: String, description: "Tooltip info"},
      }
    }


    type 'ShmcapGoalResponse', {
      properties: {
        data: {type: "ShmcapGoal", description: "ShmcapGoal records"},
      }
    }

    type 'ShmcapGoalsResponse', {
      properties: {
        data: {type: ["ShmcapGoal"], description: "ShmcapGoal records"},
      }
    }

    type 'ShmcapGoalIndexResponse', {
      properties: {
        data: {type: ["ShmcapGoal"], description: "ShmcapGoal records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of ShmcapGoal records",
      responses: standard_errors( 200 => "ShmcapGoalIndexResponse"),
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
      tags: ["ShmcapGoal"]
    get "/shmcap-goals/?" do
      self.get_list(ShmcapGoal, params)
    end

    # GET_MANY
    endpoint description: "Get ShmcapGoal record",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        ids: ["ID of ShmcapGoal", :path, false, String]
      },
      tags: ["ShmcapGoal"]
    get "/shmcap-goals/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| ShmcapGoal.get(id)}.compact})
    end

    # GET_ONE
    endpoint description: "Get ShmcapGoal record",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        id: ["ID of ShmcapGoal", :path, true, Integer]
      },
      tags: ["ShmcapGoal"]
    get "/shmcap-goals/:id" do
      json({:data => [ShmcapGoal.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create ShmcapGoal",
      responses: standard_errors( 200 => "ShmcapGoalResponse"),
      parameters: {
        data: ["ShmcapGoal", :body, true, "NewShmcapGoal"]
      },
      tags: ["ShmcapGoal"]

    post "/shmcap-goals/?", require_role: :curator do
      self.create(ShmcapGoal, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update ShmcapGoal record",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        id: ["ID of ShmcapGoal", :path, true, Integer],
        data: ["Data of ShmcapGoal", :body, true, "ShmcapGoal"]
      },
      tags: ["ShmcapGoal"]
    put "/shmcap-goals/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ShmcapGoal, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many ShmcapGoal records",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        data: ["Data of ShmcapGoals", :body, true, ["ShmcapGoal"]]
      },
      tags: ["ShmcapGoal"]
    put "/shmcap-goals/?", require_role: :curator do
        self.update_many(ShmcapGoal, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete ShmcapGoal record",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        id: ["ID of ShmcapGoal", :path, true, Integer]
      },
      tags: ["ShmcapGoal"]
    delete "/shmcap-goals/:id/?", require_role: :curator do
      self.delete_many(ShmcapGoal, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY ShmcapGoal records",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        ids: ["ID of ShmcapGoal", :path, true, String]
      },
      tags: ["ShmcapGoal"]
    delete "/shmcap-goals/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(ShmcapGoal, ids)
    end
  end
end
