require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class FundingSourcesController < Controllers::Base
    EDITABLE_FIELDS = ["name", "href"]
    type 'FundingSource', {
      properties: {
        name: {type: String, description: "Name of the funding source"},
        href: {type: String, description: "Href of the funding source"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'FundingSourceResponse', {
      properties: {
        data: {type: "FundingSource", description: "FundingSource records"},
      }
    }

    type 'FundingSourcesResponse', {
      properties: {
        data: {type: ["FundingSource"], description: "FundingSource records"},
      }
    }

    type 'FundingSourceIndexResponse', {
      properties: {
        data: {type: ["FundingSource"], description: "FundingSource records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Funding Source records",
      responses: standard_errors( 200 => "FundingSourceIndexResponse"),
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
      tags: ["Funding Source"]
    get "/funding-sources/?" do
      self.get_list(FundingSource, params)
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Funding Source record",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        ids: ["ID of FundingSource", :path, true, [Integer]]
      },
      tags: ["Funding Source"]
    get "/funding-sources/:ids" do
      self.get_one_or_many(FundingSource, params)
    end

    # CREATE
    endpoint description: "Create Funding Source",
      responses: standard_errors( 200 => "FundingSourceResponse"),
      parameters: {
        name: ["FundingSource name", :body, true, String],
        href: ["FundingSource href", :body, true, String],
      },
      tags: ["Funding Source"]

    post "/funding-sources/?", require_role: :curator do
      self.create(FundingSource, params)
    end

    # UPDATE
    endpoint description: "Update Funding Source record",
      responses: standard_errors( 200 => "FundingSourceResponse"),
      parameters: {
        id: ["ID of FundingSource", :path, true, Integer],
        data: ["Data of FundingSource", :body, true, "FundingSource"]
      },
      tags: ["Funding Source"]
    put "/funding-sources/:id/?", require_role: :curator do
      self.update_one(FundingSource, params)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Funding Source records",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        ids: ["ID of FundingSource", :body, true, [Integer]],
        data: ["Data of FundingSource", :body, true, "FundingSource"]
      },
      tags: ["Funding Source"]
    put "/funding-sources/?", require_role: :curator do
        self.update_many(FundingSource, params)
    end

    # DELETE
    endpoint description: "Delete Funding Source record",
      responses: standard_errors( 200 => "FundingSourceResponse"),
      parameters: {
        id: ["ID of FundingSource", :path, true, Integer]
      },
      tags: ["Funding Source"]
    delete "/funding-sources/:id/?", require_role: :curator do
      self.delete_record(FundingSource, params)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Funding Source records",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        ids: ["ID of FundingSource", :query, true, [Integer]]
      },
      tags: ["Funding Source"]
    delete "/funding-sources/?", require_role: :curator do
      self.delete_many(FundingSource, params)
    end

  end
end
