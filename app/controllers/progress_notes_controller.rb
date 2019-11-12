require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ProgressNotesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['note']
    end
    type 'ProgressNote', {
      properties: {
        id: {type: Integer, description: "ID"},
        note: {type: String, description: "Note content"},
        created_on: {type: Date, description: "Creation Date"},
        action_track_id: {type: Integer, description: "Action Track id"},
      }
    }
    type 'NewProgressNote', {
      properties: {
        note: {type: String, description: "Note content"},
        created_on: {type: Date, description: "Creation Date"},
        action_track_id: {type: Integer, description: "Action Track id"},
      }
    }
    type 'ProgressNotesResponse', {
      properties: {
        data: {type: ["ProgressNote"], description: "ProgressNote records"},
      }
    }

    type 'ProgressNoteResponse', {
      properties: {
        data: {type: "ProgressNote", description: "ProgressNote records"},
      }
    }

    type 'ProgressNoteIndexResponse', {
      properties: {
        data: {type: ["ProgressNote"], description: "ProgressNote records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Progress Note records",
      responses: standard_errors( 200 => "ProgressNoteIndexResponse"),
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
      tags: ["Progress Note"]
    get "/progress-notes/?" do
      self.get_list(ProgressNote, params)
    end

    # GET_MANY
    endpoint description: "Get Progress Note record",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        ids: ["ID of ProgressNote", :path, false, [Integer]]
      },
      tags: ["Progress Note"]
    get "/progress-notes/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| ProgressNote.get(id)}.compact})
    end

    # GET_ONE
    endpoint description: "Get Progress Note record",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        id: ["ID of ProgressNote", :path, true, Integer]
      },
      tags: ["Progress Note"]
    get "/progress-notes/:id" do
      json({:data => [ProgressNote.get(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Progress Note",
      responses: standard_errors( 200 => "ProgressNoteResponse"),
      parameters: {
        data: ["ProgressNote", :body, true, 'NewProgressNote'],
      },
      tags: ["Progress Note"]
    post "/progress-notes/?", require_role: :curator do
      json({:data => ProgressNote.create!(params['parsed_body']['data'])})
    end

    # UPDATE_ONE
    endpoint description: "Update one Progress Note records",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        id: ["ID of ProgressNote", :path, true, Integer],
        data: ["ProgressNote", :body, true, 'ProgressNote'],
      },
      tags: ["Progress Note"]
    put "/progress-notes/:id", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(ProgressNote, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Progress Note records",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        data: ["ProgressNote", :body, true, ['ProgressNote']],
      },
      tags: ["Progress Note"]
    put "/progress-notes/?", require_role: :curator do
      self.update_many(ProgressNote, params['parsed_body']['data'])
    end

    # DELETE_ONE
    endpoint description: "Delete One Progress Note records",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        id: ["ID of ProgressNote", :path, true, Integer]
      },
      tags: ["Progress Note"]
    delete "/action-types/:id", require_role: :curator do
      self.delete_many(ProgressNote, [params['id']].compact)
    end
    # DELETE_MANY
    endpoint description: "Delete MANY Progress Note records",
      responses: standard_errors( 200 => "ProgressNotesResponse"),
      parameters: {
        ids: ["ID of ProgressNote", :path, false, String]
      },
      tags: ["Progress Note"]
    delete "/progress-notes/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      self.delete_many(ProgressNote, ids)
    end
  end
end
