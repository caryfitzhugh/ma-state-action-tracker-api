require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class FundingSourcesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["name", "href"]
    end
    type 'FundingSource', {
      properties: {
        name: {type: String, description: "Name of the funding source"},
        href: {type: String, description: "Href of the funding source"},
        id: {type: Integer, description: "ID"}
      }
    }
    type 'NewFundingSource', {
      properties: {
        name: {type: String, description: "Name of the funding source"},
        href: {type: String, description: "Href of the funding source"},
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

    # GET_MANY
    endpoint description: "Get Funding Source record",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        ids: ["ID of FundingSource", :path, true, String]
      },
      tags: ["Funding Source"]
    get "/funding-sources/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| FundingSource.get!(id)}})
    end

    # GET_ONE
    endpoint description: "Get Funding Source record",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        id: ["ID of FundingSource", :path, true, Integer]
      },
      tags: ["Funding Source"]
    get "/action-statuses/:id" do
      json({:data => [FundingSource.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Funding Source",
      responses: standard_errors( 200 => "FundingSourceResponse"),
      parameters: {
        data: ["FundingSource", :body, true, "NewFundingSource"]
      },
      tags: ["Funding Source"]

    post "/funding-sources/?", require_role: :curator do
      self.create(FundingSource, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Funding Source record",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        id: ["ID of FundingSource", :path, true, Integer],
        data: ["Data of FundingSource", :body, true, "FundingSource"]
      },
      tags: ["Funding Source"]
    put "/funding-sources/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(FundingSource, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Funding Source records",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        data: ["Data of FundingSources", :body, true, ["FundingSource"]]
      },
      tags: ["Funding Source"]
    put "/funding-sources/?", require_role: :curator do
        self.update_many(FundingSource, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete Funding Source record",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        id: ["ID of FundingSource", :path, true, Integer]
      },
      tags: ["Funding Source"]
    delete "/funding-sources/:id/?", require_role: :curator do
      self.delete_many(FundingSource, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Funding Source records",
      responses: standard_errors( 200 => "FundingSourcesResponse"),
      parameters: {
        ids: ["ID of FundingSource", :path, false, String]
      },
      tags: ["Funding Source"]
    delete "/funding-sources/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(FundingSource, ids)
    end

  end
end
