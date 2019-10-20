require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ExecOfficesController < Controllers::Base
    EDITABLE_FIELDS = ["name", "href"]
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
      self.get_list(ExecOffice, params)
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
      self.get_one_or_many(ExecOffice, params)
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
      self.create(ExecOffice, params)
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
      self.update_one(ExecOffice, params)
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
      self.update_many(ExecOffice, params)
    end

    # DELETE
    endpoint description: "Delete Exec Office record",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/:id/?", require_role: :curator do
      self.delete_record(ExecOffic, params)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Exec Office records",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :query, true, [Integer]]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/?", require_role: :curator do
      self.delete_many(ExecOffic, params)
    end
  end
end
