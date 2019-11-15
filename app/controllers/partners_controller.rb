require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class PartnersController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['name', 'href', 'description']
    end

    type 'Partner', {
      properties: {
        name: {type: String, description: "Name of the partner"},
        href: {type: String, description: "Href of the partner"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewPartner', {
      properties: {
        name: {type: String, description: "Name of the partner"},
        href: {type: String, description: "Href of the partner"},
        description: {type: String, description: "Tooltip info"},
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
      },
      tags: ["Partner"]
    get "/partners/?" do
      self.get_list(Partner, params)
    end

    # GET_MANY
    endpoint description: "Get Partner record",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        ids: ["ID of Partner", :path, false, String],
      },
      tags: ["Partner"]
    get "/partners/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| Partner.get(id)}.compact})
    end

    # GET_ONE
    endpoint description: "Get Partner record",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        id: ["ID of Partner", :path, true, Integer]
      },
      tags: ["Partner"]
    get "/partners/:id" do
      json({:data => [Partner.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Partner",
      responses: standard_errors( 200 => "PartnerResponse"),
      parameters: {
        data: ["Partner", :body, true, "NewPartner"]
      },
      tags: ["Partner"]

    post "/partners/?", require_role: :curator do
      self.create(Partner, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Partner record",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        id: ["ID of Partner", :path, true, Integer],
        data: ["Data of Partner", :body, true, "Partner"]
      },
      tags: ["Partner"]
    put "/partners/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(Partner, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Partner records",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        data: ["Data of Partners", :body, true, ["Partner"]]
      },
      tags: ["Partner"]
    put "/partners/?", require_role: :curator do
        self.update_many(Partner, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete Partner record",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        id: ["ID of Partner", :path, true, Integer]
      },
      tags: ["Partner"]
    delete "/partners/:id/?", require_role: :curator do
      self.delete_many(Partner, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Partner records",
      responses: standard_errors( 200 => "PartnersResponse"),
      parameters: {
        ids: ["ID of Partner", :path, true, String]
      },
      tags: ["Partner"]
    delete "/partners/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(Partner, ids)
    end

  end
end
