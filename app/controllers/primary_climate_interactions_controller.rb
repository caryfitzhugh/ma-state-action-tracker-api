require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class PrimaryClimateInteractionsController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["name"]
    end

    type 'PrimaryClimateInteraction', {
      properties: {
        name: {type: String, description: "Name of the interaction"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewPrimaryClimateInteraction', {
      properties: {
        name: {type: String, description: "Name of the interaction"},
      }
    }


    type 'PrimaryClimateInteractionsResponse', {
      properties: {
        data: {type: ["PrimaryClimateInteraction"], description: "PrimaryClimateInteraction records"},
      }
    }


    type 'PrimaryClimateInteractionResponse', {
      properties: {
        data: {type: "PrimaryClimateInteraction", description: "PrimaryClimateInteraction records"},
      }
    }

    type 'PrimaryClimateInteractionIndexResponse', {
      properties: {
        data: {type: ["PrimaryClimateInteraction"], description: "PrimaryClimateInteraction records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of PrimaryClimateInteraction records",
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
      tags: ["PrimaryClimateInteraction"]
    get "/primary-climate-interactions/?" do
      self.get_list(PrimaryClimateInteraction, params)
    end

    # GET_MANY
    endpoint description: "Get PrimaryClimateInteraction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        ids: ["ID of PrimaryClimateInteraction", :query, true, [Integer]]
      },
      tags: ["PrimaryClimateInteraction"]
    get "/primary-climate-interactions/get-many/?" do
      self.get_one_or_many(PrimaryClimateInteraction, params['ids'])
    end

    # GET_ONE
    endpoint description: "Get PrimaryClimateInteraction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        id: ["ID of PrimaryClimateInteraction", :path, true, Integer]
      },
      tags: ["PrimaryClimateInteraction"]
    get "/action-statuses/:id" do
      self.get_one_or_many(PrimaryClimateInteraction, [params["id"]])
    end

    # CREATE
    endpoint description: "Create PrimaryClimateInteraction",
      responses: standard_errors( 200 => "PrimaryClimateInteractionResponse"),
      parameters: {
        data: ["PrimaryClimateInteraction", :body, true, "NewPrimaryClimateInteraction"]
      },
      tags: ["PrimaryClimateInteraction"]

    post "/primary-climate-interactions/?", require_role: :curator do
      self.create(PrimaryClimateInteraction, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update PrimaryClimateInteraction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        id: ["ID of PrimaryClimateInteraction", :path, true, Integer],
        data: ["Data of PrimaryClimateInteraction", :body, true, "PrimaryClimateInteraction"]
      },
      tags: ["PrimaryClimateInteraction"]
    put "/primary-climate-interactions/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(PrimaryClimateInteraction, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many PrimaryClimateInteraction records",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        data: ["Data of PrimaryClimateInteractions", :body, true, ["PrimaryClimateInteraction"]]
      },
      tags: ["PrimaryClimateInteraction"]
    put "/primary-climate-interactions/?", require_role: :curator do
        self.update_many(PrimaryClimateInteraction, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete PrimaryClimateInteraction record",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        id: ["ID of PrimaryClimateInteraction", :path, true, Integer]
      },
      tags: ["PrimaryClimateInteraction"]
    delete "/primary-climate-interactions/:id/?", require_role: :curator do
      self.delete_many(PrimaryClimateInteraction, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY PrimaryClimateInteraction records",
      responses: standard_errors( 200 => "PrimaryClimateInteractionsResponse"),
      parameters: {
        ids: ["ID of PrimaryClimateInteraction", :query, true, [Integer]]
      },
      tags: ["PrimaryClimateInteraction"]
    delete "/primary-climate-interactions/?", require_role: :curator do
      self.delete_many(PrimaryClimateInteraction, params['ids'])
    end
  end
end
