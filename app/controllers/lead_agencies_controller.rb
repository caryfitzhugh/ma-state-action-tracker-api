require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class LeadAgenciesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['name', 'href']
    end

    type 'LeadAgency', {
      properties: {
        name: {type: String, description: "Name of the agency"},
        href: {type: String, description: "Href of the agency"},
        id: {type: Integer, description: "ID"}
      }
    }
    type 'NewLeadAgency', {
      properties: {
        name: {type: String, description: "Name of the agency"},
        href: {type: String, description: "Href of the agency"},
      }
    }

    type 'LeadAgencyResponse', {
      properties: {
        data: {type: "LeadAgency", description: "LeadAgency records"},
      }
    }

    type 'LeadAgenciesResponse', {
      properties: {
        data: {type: ["LeadAgency"], description: "LeadAgency records"},
      }
    }

    type 'LeadAgencyIndexResponse', {
      properties: {
        data: {type: ["LeadAgency"], description: "LeadAgency records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Lead Agency records",
      responses: standard_errors( 200 => "LeadAgencyIndexResponse"),
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
      tags: ["Lead Agency"]
    get "/lead-agencies/?" do
      self.get_list(LeadAgency, params)
    end

    # GET_MANY
    endpoint description: "Get Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :query, true, [Integer]]
      },
      tags: ["Lead Agency"]
    get "/lead-agencies/get-many/?" do
      self.get_one_or_many(LeadAgency, params['ids'])
    end


    # GET_ONE
    endpoint description: "Get Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer]
      },
      tags: ["Lead Agency"]
    get "/action-statuses/:id" do
      self.get_one_or_many(LeadAgency, [params["id"]])
    end

    # CREATE
    endpoint description: "Create Lead Agency",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        data: ["LeadAgency", :body, true, "NewLeadAgency"]
      },
      tags: ["Lead Agency"]

    post "/lead-agencies/?", require_role: :curator do
      self.create(LeadAgency, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer],
        data: ["Data of LeadAgency", :body, true, "LeadAgency"]
      },
      tags: ["Lead Agency"]
    put "/lead-agencies/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(LeadAgency, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Lead Agency records",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        data: ["Data of LeadAgencies", :body, true, ["LeadAgency"]]
      },
      tags: ["Lead Agency"]
    put "/lead-agencies/?", require_role: :curator do
        self.update_many(LeadAgency, params['parsed_body']['data'])
    end

    # DELETE
    endpoint description: "Delete Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer]
      },
      tags: ["Lead Agency"]
    delete "/lead-agencies/:id/?", require_role: :curator do
      self.delete_many(LeadAgency, [params['id']].compact)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Lead Agency records",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :query, true, [Integer]]
      },
      tags: ["Lead Agency"]
    delete "/lead-agencies/?", require_role: :curator do
      self.delete_many(LeadAgency, params['ids'])
    end

  end
end
