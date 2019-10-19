require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class AgencyPrioritiesController < Controllers::Base
    EDITABLE_FIELDS = ['name']

    type 'AgencyPriority', {
      properties: {
        name: {type: String, description: "Name of the priority"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'AgencyPrioritiesResponse', {
      properties: {
        data: {type: ["AgencyPriority"], description: "AgencyPriority records"},
      }
    }

    type 'AgencyPriorityResponse', {
      properties: {
        data: {type: "AgencyPriority", description: "AgencyPriority records"},
      }
    }

    type 'AgencyPriorityIndexResponse', {
      properties: {
        data: {type: ["AgencyPriority"], description: "AgencyPriority records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Agency Priority records",
      responses: standard_errors( 200 => "AgencyPriorityIndexResponse"),
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
      tags: ["Agency Priority"]
    get "/agency-priorities/?" do
      objs = AgencyPriority
      (params["filter"] || "").split("&").each do |fv|
        field, value = fv.split("=", 2)
        objs = objs.all(field => value)
      end

      order = (params["sort_by_field"] || "name").to_sym
      if params["sort_by_order"] == "desc"
          order = [order.desc]
      elsif params["sort_by_order"] == "asc"
          order = [order.asc]
      end
      objs = objs.all(:order => order).page(params["page"], :per_page => params["per_page"])
      json(data: objs,
           total: objs.count
          )
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :path, true, [Integer]]
      },
      tags: ["Agency Priority"]
    get "/agency-priorities/:ids" do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        AgencyPriority.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Agency Priority",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        name: ["AgencyPriority name", :body, true, String],
      },
      tags: ["Agency Priority"]

    post "/agency-priorities/?", require_role: :curator do
      ap = AgencyPriority.create(slice(*EDITABLE_FIELDS))
      puts(ap.to_json)
      json(data: ap)
    end

    # UPDATE
    endpoint description: "Update Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/:id/?", require_role: :curator do
      ap = AgencyPriority.get!(params["id"])
      ap.update!(params[:data].slice(*EDITABLE_FIELDS))
      return json(data: ap)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :body, true, [Integer]],
        data: ["Data of AgencyPriority", :body, true, "AgencyPriority"]
      },
      tags: ["Agency Priority"]
    put "/agency-priorities/?", require_role: :curator do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        ap = AgencyPriority.get!(id)
        ap.update!(params[:data].slice(*EDITABLE_FIELDS))
        ap
      end
      return json(data: data)
    end

    # DELETE
    endpoint description: "Delete Agency Priority record",
      responses: standard_errors( 200 => "AgencyPriorityResponse"),
      parameters: {
        id: ["ID of AgencyPriority", :path, true, Integer]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/:id/?", require_role: :curator do
      ap = AgencyPriority.get!(params["id"])
      ap.destroy!
      return json(data: ap)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Agency Priority records",
      responses: standard_errors( 200 => "AgencyPrioritiesResponse"),
      parameters: {
        ids: ["ID of AgencyPriority", :query, true, [Integer]]
      },
      tags: ["Agency Priority"]
    delete "/agency-priorities/?", require_role: :curator do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        ap = AgencyPriority.get!(id)
        ap.destroy!
        ap
      end
      return json(data: data)
    end
  end
end
