require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class PrimaryClimateInteractionsController < Controllers::Base
    type 'PrimaryClimateInteraction', {
      properties: {
        name: {type: String, description: "Name of the interaction"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'PrimaryClimateInteractionResponse', {
      properties: {
        data: {type: ["PrimaryClimateInteraction"], description: "PrimaryClimateInteraction records"},
      }
    }

    type 'PrimaryClimateInteractionIndexResponse', {
      properties: {
        data: {type: ["PrimaryClimateInteraction"], description: "PrimaryClimateInteraction records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Primary Climate Interaction records",
      responses: standard_errors( 200 => "PrimaryClimateInteractionIndexResponse"),
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
      tags: ["Primary Climate Interaction"]
    get "/primary-climate-interactions/?" do
        raise "NOT IMPLEMENTED"
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Primary Climate Interaction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        ids: ["ID of PrimaryClimateInteraction", :path, true, [Integer]]
      },
      tags: ["Primary Climate Interaction"]
    get "/primary-climate-interactions/:ids" do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        PrimaryClimateInteraction.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Primary Climate Interaction",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        name: ["PrimaryClimateInteraction name", :body, true, String],
      },
      tags: ["Primary Climate Interaction"]

    post "/primary-climate-interactions/?", require_role: :curator do
      raise "NOT IMPLEMENTED"
    end

    # UPDATE
    endpoint description: "Update Primary Climate Interaction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        id: ["ID of PrimaryClimateInteraction", :path, true, Integer],
        data: ["Data of PrimaryClimateInteraction", :body, true, "PrimaryClimateInteraction"]
      },
      tags: ["Primary Climate Interaction"]
    put "/primary-climate-interactions/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # UPDATE_MANY
    endpoint description: "Update Many Primary Climate Interaction records",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        ids: ["ID of PrimaryClimateInteraction", :body, true, [Integer]],
        data: ["Data of PrimaryClimateInteraction", :body, true, "PrimaryClimateInteraction"]
      },
      tags: ["Primary Climate Interaction"]
    put "/primary-climate-interactions/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE
    endpoint description: "Delete Primary Climate Interaction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        id: ["ID of PrimaryClimateInteraction", :path, true, Integer]
      },
      tags: ["Primary Climate Interaction"]
    delete "/primary-climate-interactions/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Primary Climate Interaction records",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        ids: ["ID of PrimaryClimateInteraction", :query, true, [Integer]]
      },
      tags: ["Primary Climate Interaction"]
    delete "/primary-climate-interactions/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end
  end
end
