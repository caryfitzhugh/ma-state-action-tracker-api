require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class LeadAgenciesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['name', 'href', 'description']
    end

    type 'LeadAgency', {
      properties: {
        name: {type: String, description: "Name of the agency"},
        href: {type: String, description: "Href of the agency"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }
    type 'NewLeadAgency', {
      properties: {
        name: {type: String, description: "Name of the agency"},
        href: {type: String, description: "Href of the agency"},
        description: {type: String, description: "Tooltip info"},
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
                maximum: 5000,
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
        ids: ["ID of LeadAgency", :path, false, String]
      },
      tags: ["Lead Agency"]
    get "/lead-agencies/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| LeadAgency.get(id)}.compact})
    end


    # GET_ONE
    endpoint description: "Get Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer]
      },
      tags: ["Lead Agency"]
    get "/lead-agencies/:id" do
      json({:data => [LeadAgency.get!(params["id"])]})
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

    def clear_relationships(ids)
      ActionTrack.all(:lead_agency_id => ids).each do |at|
        at.lead_agency_id = nil
        at.save!
      end
    end

    # DELETE
    endpoint description: "Delete Lead Agency record",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        id: ["ID of LeadAgency", :path, true, Integer]
      },
      tags: ["Lead Agency"]
    delete "/lead-agencies/:id/?", require_role: :curator do
      ids = [params['id']].compact
      clear_relationships(ids)
      self.delete_many(LeadAgency, ids)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Lead Agency records",
      responses: standard_errors( 200 => "LeadAgenciesResponse"),
      parameters: {
        ids: ["ID of LeadAgency", :path, true, String]
      },
      tags: ["Lead Agency"]
    delete "/lead-agencies/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      clear_relationships(ids)
      self.delete_many(LeadAgency, ids)
    end

  end
end
