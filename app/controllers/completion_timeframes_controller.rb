require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class CompletionTimeframesController < Controllers::Base
    def self.EDITABLE_FIELDS
      ['timeframe']
    end

    type 'CompletionTimeframe', {
      properties: {
        timeframe: {type: String, description: "timeframe"},
        id: {type: Integer, description: "ID"}
      }
    }

    type 'NewCompletionTimeframe', {
      properties: {
        timeframe: {type: String, description: "timeframe"},
      }
    }

    type 'CompletionTimeframesResponse', {
      properties: {
        data: {type: ["CompletionTimeframe"], description: "CompletionTimeframe records"},
      }
    }

    type 'CompletionTimeframeResponse', {
      properties: {
        data: {type: "CompletionTimeframe", description: "CompletionTimeframe records"},
      }
    }

    type 'CompletionTimeframeIndexResponse', {
      properties: {
        data: {type: ["CompletionTimeframe"], description: "CompletionTimeframe records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Completion Timeframe records",
      responses: standard_errors( 200 => "CompletionTimeframeIndexResponse"),
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
      tags: ["Completion Timeframe"]
    get "/completion-timeframes/?" do
      self.get_list(CompletionTimeframe, params)
    end

    # GET_MANY
    endpoint description: "Get Completion Timeframe record",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        ids: ["ID of CompletionTimeframe", :path, false, String]
      },
      tags: ["Completion Timeframe"]
    get "/completion-timeframes/get-many/(:ids)?" do
      ids = [(params[:ids] || "").split(',')].flatten.compact.map(&:to_i)
      json({:data => ids.map {|id| CompletionTimeframe.get(id)}.compact})
    end


    # GET_ONE
    endpoint description: "Get Completion Timeframe record",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        id: ["ID of CompletionTimeframe", :path, true, Integer]
      },
      tags: ["Completion Timeframe"]
    get "/completion-timeframes/:id" do
      json({:data => [CompletionTimeframe.get!(params["id"])]})
    end

    # CREATE
    endpoint description: "Create Completion Timeframe",
      responses: standard_errors( 200 => "CompletionTimeframeResponse"),
      parameters: {
        data: ["CompletionTimeframe", :body, true, 'NewCompletionTimeframe'],
      },
      tags: ["Completion Timeframe"]

    post "/completion-timeframes/?", require_role: :curator do
      self.create(CompletionTimeframe, params['parsed_body']['data'])
    end

    # UPDATE_ONE
    endpoint description: "Update One Completion Timeframe records",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        id: ["ID of CompletionTimeframe", :path, true, Integer],
        data: ["CompletionTimeframe", :body, true, 'CompletionTimeframe'],
      },
      tags: ["Completion Timeframe"]
    put "/completion-timeframes/:id", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']
      self.update_many(CompletionTimeframe, [data])
    end

    # UPDATE_MANY
    endpoint description: "Update Many Completion Timeframe records",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        data: ["CompletionTimeframe", :body, true, ['CompletionTimeframe']],
      },
      tags: ["Completion Timeframe"]
    put "/completion-timeframes/?", require_role: :curator do
      self.update_many(CompletionTimeframe, params['parsed_body']['data'])
    end

    def clear_relationships(ids)
      ActionTrack.all(:completion_timeframe_id => ids).each do |at|
        at.completion_timeframe_id = nil
        at.save!
      end
    end

    # DELETE_ONE
    endpoint description: "Delete MANY Completion Timeframe records",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        id: ["ID of CompletionTimeframe", :path, true, Integer]
      },
      tags: ["Completion Timeframe"]
    delete "/completion-timeframes/:id", require_role: :curator do
      ids = [params['id']].compact
      clear_relationships(ids)
      self.delete_many(CompletionTimeframe, ids)
    end
    # DELETE_MANY
    endpoint description: "Delete MANY Completion Timeframe records",
      responses: standard_errors( 200 => "CompletionTimeframesResponse"),
      parameters: {
        ids: ["ID of CompletionTimeframe", :path, false, String]
      },
      tags: ["Completion Timeframe"]
    delete "/completion-timeframes/:ids", require_role: :curator do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      clear_relationships(ids)
      self.delete_many(CompletionTimeframe, params['ids'])
    end
  end
end
