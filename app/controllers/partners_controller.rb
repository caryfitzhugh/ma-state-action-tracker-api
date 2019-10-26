require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class PartnersController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['name', 'href']
    end

    type 'Partner', {
      properties: {
        name: {type: String, description: "Name of the partner"},
        href: {type: String, description: "Href of the partner"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'PartnersResponse', {
      properties: {
        data: {type: ["Partner"], description: "Partner records"},
      }
    }

    type 'PartnerResponse', {
      properties: {
        data: {type: "Partner", description: "Partner records"},
      }
    }

    type 'PartnerIndexResponse', {
      properties: {
        data: {type: ["Partner"], description: "Partner records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Partner records",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnerIndexResponse"),
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
      }
    get "/partners/?" do
      self.get_list(Partner, params)
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Partner record",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        ids: ["ID of Partner", :path, true, [Integer]]
      }
    get "/partners/:ids" do
      self.get_one_or_many(Partner, params)
    end

    # CREATE
    endpoint description: "Create Partner",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnerResponse"),
      parameters: {
        name: ["Partner name", :body, true, String],
        href: ["Partner href", :body, true, String],
      }

    post "/partners/?", require_role: :curator do
      self.create(Partner, params)
    end

    # UPDATE
    endpoint description: "Update Partner record",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnerResponse"),
      parameters: {
        id: ["ID of Partner", :path, true, Integer],
        data: ["Data of Partner", :body, true, "Partner"]
      }
    put "/partners/:id/?", require_role: :curator do
      self.update_one(Partner, params)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Partner records",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        ids: ["ID of Partner", :body, true, [Integer]],
        data: ["Data of Partner", :body, true, "Partner"]
      }
    put "/partners/?", require_role: :curator do
      self.update_many(Partner, params)
    end

    # DELETE
    endpoint description: "Delete Partner record",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnerResponse"),
      parameters: {
        id: ["ID of Partner", :path, true, Integer]
      }
    delete "/partners/:id/?", require_role: :curator do
      self.delete_record(Partner, params)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Partner records",
      tags: ["Partner"],
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        ids: ["ID of Partner", :query, true, [Integer]]
      }
    delete "/partners/?", require_role: :curator do
      self.delete_many(Partner, params)
    end
  end
end
