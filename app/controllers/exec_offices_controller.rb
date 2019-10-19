require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ExecOfficesController < Controllers::Base
    type 'ExecOffice', {
      properties: {
        name: {type: String, description: "Name of the office"},
        href: {type: String, description: "Href of the office"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'ExecOfficeCreate', {
      properties: {
        name: {type: String, description: "Name of the office"},
        href: {type: String, description: "Href of the office"},
      }
    }

    type 'ExecOfficesResponse', {
      properties: {
        data: {type: ["ExecOffice"], description: "ExecOffice records"},
      }
    }

    type 'ExecOfficeResponse', {
      properties: {
        data: {type: "ExecOffice", description: "ExecOffice records"},
      }
    }

    type 'ExecOfficeIndexResponse', {
      properties: {
        data: {type: ["ExecOffice"], description: "ExecOffice records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Exec Office records",
      responses: standard_errors( 200 => "ExecOfficeIndexResponse"),
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
        filter: ["Filter to sort on query string format (field=value&field2=value)", :query, false, String],
      },
      tags: ["Exec Office"]
    get "/exec-offices/?" do
      objs = ExecOffice
      require 'pry'
      binding.pry
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
    endpoint description: "Get Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :path, true, [Integer]]
      },
      tags: ["Exec Office"]
    get "/exec-offices/:ids" do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        ExecOffice.get!(id)
      end
      return json(data: data)
    end

    # CREATE
    endpoint description: "Create Exec Offic",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        name: ["ExecOffice name", :query, true, String],
        href: ["ExecOffice href link", :query, false, String],
      },
      tags: ["Exec Office"]

    post "/exec-offices/?", require_role: :curator do
      eo = ExecOffice.create(slice('name', 'href'))
      puts(eo.to_json)
      json(data: eo)
    end

    # UPDATE
    endpoint description: "Update Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer],
        data: ["Data of ExecOffice", :body, true, "ExecOffice"]
      },
      tags: ["Exec Office"]
    put "/exec-offices/:id/?", require_role: :curator do
      eo = ExecOffice.get!(params["id"])
      eo.update!(params[:data].slice(:name, :href))
      return json(data: eo)
    end

    # UPDATE_MANY
    endpoint description: "Update Many Exec Office records",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :body, true, [Integer]],
        data: ["Data of ExecOffice", :body, true, "ExecOffice"]
      },
      tags: ["Exec Office"]
    put "/exec-offices/?", require_role: :curator do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        eo = ExecOffice.get!(id)
        eo.update!(params[:data].slice(:name, :href))
        eo
      end
      return json(data: data)
    end

    # DELETE
    endpoint description: "Delete Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/:id/?", require_role: :curator do
      eo = ExecOffice.get!(params["id"])
      eo.destroy!
      return json(data: eo)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Exec Office records",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :query, true, [Integer]]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/?", require_role: :curator do
      data = (params["ids"].split(",")).map(&:to_i).map do |id|
        eo = ExecOffice.get!(id)
        eo.destroy!
        eo
      end
      return json(data: data)
    end
  end
end
