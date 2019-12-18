require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ExecOfficesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["name", "href", 'description']
    end

    type 'ExecOffice', {
      properties: {
        name: {type: String, description: "Name of the office"},
        href: {type: String, description: "Href of the office"},
        description: {type: String, description: "Tooltip info"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewExecOffice', {
      properties: {
        name: {type: String, description: "Name of the office"},
        href: {type: String, description: "Href of the office"},
        description: {type: String, description: "Tooltip info"},
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
                maximum: 5000,
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

    # GET_MANY
    endpoint description: "Get Exec Office record",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :path, false, String]
      },
      tags: ["Exec Office"]
    get "/exec-offices/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)

      json({:data => ids.map {|id| ExecOffice.get(id)}.compact})
    end


    # GET_ONE
    endpoint description: "Get Exec Office record",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer]
      },
      tags: ["Exec Office"]
    get "/exec-offices/:id" do
      json({:data => [ExecOffice.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Exec Offic",
      responses: standard_errors( 200 => "ExecOfficeResponse"),
      parameters: {
        data: ["ExecOffice", :body, true, 'NewExecOffice'],
      },
      tags: ["Exec Office"]

    post "/exec-offices/?", require_role: :curator do
      self.create(ExecOffice, params['parsed_body']['data'])
    end

    # UPDATE
    endpoint description: "Update Exec Office record",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer],
        data: ["Data of ExecOffice", :body, true, "ExecOffice"]
      },
      tags: ["Exec Office"]
    put "/exec-offices/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ExecOffice, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Exec Office records",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        data: ["Data of ExecOffice", :body, true, ["ExecOffice"]]
      },
      tags: ["Exec Office"]
    put "/exec-offices/?", require_role: :curator do
      self.update_many(ExecOffice, params['parsed_body']['data'])
    end

    def clear_relationships(ids)
      ActionTrack.all(:exec_office_id => ids).each do |at|
        at.exec_office_id = nil
        at.save!
      end
    end

    # DELETE
    endpoint description: "Delete Exec Office record",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        id: ["ID of ExecOffice", :path, true, Integer]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/:id/?", require_role: :curator do
      ids = [params['id']].compact
      clear_relationships(ids)
      self.delete_many(ExecOffice, ids)
    end

    # DELETE_MANY
    endpoint description: "Delete MANY Exec Office records",
      responses: standard_errors( 200 => "ExecOfficesResponse"),
      parameters: {
        ids: ["ID of ExecOffice", :path, false, String]
      },
      tags: ["Exec Office"]
    delete "/exec-offices/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      clear_relationships(ids)
      self.delete_many(ExecOffice, ids)
    end
  end
end
