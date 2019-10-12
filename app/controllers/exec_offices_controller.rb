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

    type 'ExecOfficeResponse', {
      properties: {
        data: {type: ["ExecOffice"], description: "ExecOffice records"},
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
        filter: ["Filter to sort on {field_name: value}", :query, false, String],
      }
    get "/exec-offices/?" do
        raise "NOT IMPLEMENTED"
    end

    # GET_ONE
    # GET_MANY
    endpoint description: "Get Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :path, true, [Integer]]
      }
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
        name: ["ExecOffice name", :body, true, String],
        href: ["ExecOffice href", :body, true, String],
      }

    post "/exec-offices/?", require_role: :curator do
      raise "NOT IMPLEMENTED"
    end

    # UPDATE
    endpoint description: "Update Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer],
        data: ["Data of ExecOffice", :body, true, "ExecOffice"]
      }
    put "/exec-offices/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # UPDATE_MANY
    endpoint description: "Update Many Exec Office records",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :body, true, [Integer]],
        data: ["Data of ExecOffice", :body, true, "ExecOffice"]
      }
    put "/exec-offices/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE
    endpoint description: "Delete Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer]
      }
    delete "/exec-offices/:id/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Exec Office records",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :query, true, [Integer]]
      }
    delete "/exec-offices/?", require_role: :curator do
        raise "NOT IMPLEMENTED"
    end

  end
end
