require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class AuditTrailsController < Controllers::Base
    def self.EDITABLE_FIELDS
      []
    end

    type 'AuditTrail', {
      properties: {
        auditable_type: {type: String},
        auditable_id: {type: Integer},
        created_at: {type: DateTime, description: "When audit occurred"},
        changes: {type: String},
        action: {type: String},
        user_id: { type: String, description: "Who did the action"},
        id: {type: Integer, description: "ID"}
      }
    }
    type 'AuditTrailsResponse', {
      properties: {
        data: {type: ["AuditTrail"], description: "AuditTrail records"},
      }
    }

    type 'AuditTrailIndexResponse', {
      properties: {
        data: {type: ["AuditTrail"], description: "AuditTrail records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Audit Trail records",
      responses: standard_errors( 200 => "AuditTrailIndexResponse"),
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
      tags: ["Audit Trail"]
    get "/audit-trails/?" do
      self.get_list(DataMapper::Audited::Audit, params)
    end

    # GET_MANY
    endpoint description: "Get Audit Trail record",
      responses: standard_errors( 200 => "AuditTrailsResponse"),
      parameters: {
        ids: ["ID of AuditTrail", :path, false, [Integer]]
      },
      tags: ["Audit Trail"]
    get "/audit-trails/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| AuditTrail.get(id)}.compact})
    end

    # GET_ONE
    endpoint description: "Get Audit Trail record",
      responses: standard_errors( 200 => "AuditTrailsResponse"),
      parameters: {
        id: ["ID of AuditTrail", :path, true, Integer]
      },
      tags: ["Audit Trail"]
    get "/audit-trails/:id" do
      json({:data => [AuditTrail.get!(params["id"])]})
    end
  end
end
