require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class LeadAgenciesController < Controllers::Base
    type 'LeadAgency', {
      properties: {
        name: {type: String, description: "Name of the agency"},
        href: {type: String, description: "Href of the agency"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'LeadAgencyResponse', {
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
      }
    get "/lead-agencies/?" do
        raise "NOT IMPLEMENTED"
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Lead Agency record",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :path, true, [Integer]]
      }
    get "/lead-agencies/:ids" do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        LeadAgency.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Lead Agency",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        name: ["LeadAgency name", :body, true, String],
        href: ["LeadAgency href", :body, true, String],
      }

    post "/lead-agencies/?", require_role: :curator do
      raise "NOT IMPLEMENTED"
    end

    # UPDATE
    endpoint description: "Update Lead Agency record",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer],
        data: ["Data of LeadAgency", :body, true, "LeadAgency"]
      }
    put "/lead-agencies/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # UPDATE_MANY
    endpoint description: "Update Many Lead Agency records",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :body, true, [Integer]],
        data: ["Data of LeadAgency", :body, true, "LeadAgency"]
      }
    put "/lead-agencies/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE
    endpoint description: "Delete Lead Agency record",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer]
      }
    delete "/lead-agencies/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Lead Agency records",
      responses: standard_errors( 200 => "LeadAgencyResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :query, true, [Integer]]
      }
    delete "/lead-agencies/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

  end
end
