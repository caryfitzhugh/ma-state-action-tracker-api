require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ShmcapGoalsController < Controllers::Base
    EDITABLE_FIELDS = ["name"]
    type 'ShmcapGoal', {
      properties: {
        name: {type: String, description: "Name of the goal"},
        id: {type: Integer, description: "ID"}
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
    endpoint description: "Get List of Shmcap Goal records",
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
      tags: ["Shmcap Goal"]
    get "/shmcap-goals/?" do
      self.get_list(ShmcapGoal, params)
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Shmcap Goal record",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        ids: ["ID of ShmcapGoal", :path, true, [Integer]]
      },
      tags: ["Shmcap Goal"]
    get "/shmcap-goals/:ids" do
      self.get_one_or_many(ShmcapGoal, params)
    end

    # CREATE
    endpoint description: "Create Shmcap Goal",
      responses: standard_errors( 200 => "ShmcapGoalResponse"),
      parameters: {
        name: ["ShmcapGoal name", :body, true, String],
      },
      tags: ["Shmcap Goal"]

    post "/shmcap-goals/?", require_role: :curator do
      self.create(ShmcapGoal, params)
    end

    # UPDATE
    endpoint description: "Update Shmcap Goal record",
      responses: standard_errors( 200 => "ShmcapGoalResponse"),
      parameters: {
        id: ["ID of ShmcapGoal", :path, true, Integer],
        data: ["Data of ShmcapGoal", :body, true, "ShmcapGoal"]
      },
      tags: ["Shmcap Goal"]
    put "/shmcap-goals/:id/?", require_role: :curator do
      self.update_one(ShmcapGoal, params)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Shmcap Goal records",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        ids: ["ID of ShmcapGoal", :body, true, [Integer]],
        data: ["Data of ShmcapGoal", :body, true, "ShmcapGoal"]
      },
      tags: ["Shmcap Goal"]
    put "/shmcap-goals/?", require_role: :curator do
      self.update_many(ShmcapGoal, params)
    end

    # DELETE
    endpoint description: "Delete Shmcap Goal record",
      responses: standard_errors( 200 => "ShmcapGoalResponse"),
      parameters: {
        id: ["ID of ShmcapGoal", :path, true, Integer]
      },
      tags: ["Shmcap Goal"]
    delete "/shmcap-goals/:id/?", require_role: :curator do
      self.delete_record(ShmcapGoal, params)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Shmcap Goal records",
      responses: standard_errors( 200 => "ShmcapGoalsResponse"),
      parameters: {
        ids: ["ID of ShmcapGoal", :query, true, [Integer]]
      },
      tags: ["Shmcap Goal"]
    delete "/shmcap-goals/?", require_role: :curator do
      self.delete_many(ShmcapGoal, params)
    end
  end
end
