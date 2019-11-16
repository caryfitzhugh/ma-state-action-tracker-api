require 'app/controllers/base'
require 'app/models'
require 'uri'

module Controllers
  class ActionTracksController < Controllers::Base
    def self.EDITABLE_FIELDS
      ["title",
       "description",
       "completion_timeframe_id",
       "action_status_id",
       "exec_office_id",
       "lead_agency_id",
       "agency_priority_id",
       "global_action_id"
      ]
    end

    def action_track_obj(ap)
      if ap
        JSON.load(ap.to_json).tap do |o|
          o[:action_type_ids] = ap.action_types.map(&:id)
          o[:partner_ids] = ap.partners.map(&:id)
          o[:funding_source_ids] = ap.funding_sources.map(&:id)
          o[:shmcap_goal_ids] = ap.shmcap_goals.map(&:id)
          o[:primary_climate_interaction_ids] = ap.primary_climate_interactions.map(&:id)
          o[:progress_note_ids] = ap.progress_notes.map(&:id)
        end
      else
        {}
      end
    end

    def action_track_delete(ap)
      ap.partners = []
      ap.funding_sources = []
      ap.shmcap_goals =  []
      ap.primary_climate_interactions =  []
      ap.progress_notes = []
      ap.action_types = []
      ap.save!
      ap.destroy!
    end

    def action_track_update(ap, fields)
      ap.action_types = (fields['action_type_ids'] || []).map do |atid|
        ActionType.get(atid)
      end

      ap.partners = (fields['partner_ids'] || []).map do |pid|
        Partner.get(pid)
      end

      ap.funding_sources = (fields['funding_source_ids'] || []).map do |fsid|
        FundingSource.get(fsid)
      end

      ap.shmcap_goals = (fields['shmcap_goal_ids'] || []).map do |sgid|
        ShmcapGoal.get(sgid)
      end

      ap.primary_climate_interactions = (fields['primary_climate_interaction_ids'] || []).map do |pciid|
        PrimaryClimateInteraction.get(pciid)
      end
    end

    type 'ActionTrack', {
      properties: {
        :id => {type: Integer},
        :title => {type: String},
        :description => {type: String},
        :start_on => {type: String, example: "2017-01-31"},
        :end_on => {type: String, example: "2017-01-31"},

        :action_status_id => {type: Integer, description: "Action Status ID"},
        :exec_office_id => {type: Integer, description: "Exec Office ID"},
        :lead_agency_id => {type: Integer, description: "Lead Agency ID"},
        :agency_priority_id => {type: Integer, description: "Agency priority ID"},
        :global_action_id => {type: Integer, description: "Global action ID"},
        :action_type_ids => {type: [Integer], description: "Action Type IDs"},
        :partner_ids => {type: [Integer], description: "Partners ids"},
        :funding_source_ids => {type: [Integer], description: "Funding Source IDs"},
        :shmcap_goal_ids => {type: [Integer], description: "SHMCAP Goal IDs"},
        :primary_climate_interaction_ids => {type: [Integer], description: "Primary Climate Change IDs"}
      }
    }

    type 'NewActionTrack', {
      properties: {
        :title => {type: String},
        :description => {type: String},
        :start_on => {type: String, example: "2017-01-31"},
        :end_on => {type: String, example: "2017-01-31"},

        :action_status_id => {type: Integer, description: "Action Status ID"},
        :exec_office_id => {type: Integer, description: "Exec Office ID"},
        :lead_agency_id => {type: Integer, description: "Lead Agency ID"},
        :agency_priority_id => {type: Integer, description: "Agency priority ID"},
        :global_action_id => {type: Integer, description: "Global action ID"},
        :action_type_ids => {type: [Integer], description: "Action Type IDs"},
        :partner_ids => {type: [Integer], description: "Partners ids"},
        :funding_source_ids => {type: [Integer], description: "Funding Source IDs"},
        :shmcap_goal_ids => {type: [Integer], description: "SHMCAP Goal IDs"},
        :primary_climate_interaction_ids => {type: [Integer], description: "Primary Climate Change IDs"}
      }
    }

    type 'ActionTracksResponse', {
      properties: {
        data: {type: ["ActionTrack"], description: "ActionTrack records"},
      }
    }

    type 'ActionTrackResponse', {
      properties: {
        data: {type: "ActionTrack", description: "ActionTrack records"},
      }
    }

    type 'ActionTrackIndexResponse', {
      properties: {
        data: {type: ["ActionTrack"], description: "ActionTrack records"},
        total: {type: Integer, description: "total count"},
      }
    }

    # GET_LIST
    endpoint description: "Get List of Action Track records",
      responses: standard_errors( 200 => "ActionTrackIndexResponse"),
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
        query: ["Query string to search with", :query, false, String]
      },
      tags: ["Action Track"]

    get "/action-tracks/?" do
      objs = ActionTrack.all

      JSON.parse(params["filter"] || "{}").each do |field, value|
        if field == "shmcap_goal_ids"
          objs = objs.all(ActionTrack.shmcap_goals.id => value)
        elsif field == 'action_type_ids'
          objs = objs.all(ActionTrack.action_types.id => value)
        else
          objs = objs.all(field => value)
        end
      end

      order = (params["sort_by_field"] || self.class.EDITABLE_FIELDS[0]).to_sym
      # Can only order on a few fields
      if order == :title
        order = [order.send(params["sort_by_order"].downcase.to_sym)]
      elsif order == :description
        order = [order.send(params["sort_by_order"].downcase.to_sym)]
      end

      objs = objs.page(params["page"], :per_page => params["per_page"]).all(:order => order)

      if params["query"]
        q = "%" + params['query'] + "%"

        objs =
          objs.all(:title.ilike => q) |
          objs.all(:description.ilike => q) |
          objs.all(ActionTrack.action_types.type.ilike => q) |
          objs.all(ActionTrack.action_status.status.ilike => q) |
          objs.all(ActionTrack.completion_timeframe.timeframe.ilike => q) |
          objs.all(ActionTrack.exec_office.name.ilike => q) |
          objs.all(ActionTrack.lead_agency.name.ilike => q) |
          objs.all(ActionTrack.agency_priority.name.ilike => q) |
          objs.all(ActionTrack.global_action.action.ilike => q) |
          objs.all(ActionTrack.partners.name.ilike => q) |
          objs.all(ActionTrack.partners.href.ilike => q) |
          objs.all(ActionTrack.funding_sources.name.ilike => q) |
          objs.all(ActionTrack.funding_sources.href.ilike => q) |
          objs.all(ActionTrack.primary_climate_interactions.name.ilike => q)
      end

      json(data: objs.map {|o| action_track_obj(o) },
           total: objs.count
          )
    end

    # GET_MANY
    endpoint description: "Get ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :path, false, String]
      },
      tags: ["ActionTrack"]
    get "/action-tracks/get-many/?:ids" do
      ids = [params[:ids].split(',')].flatten.compact.map(&:to_i)
      json({:data => (ids).map {|id| action_track_obj(ActionTrack.get(id))}})
    end


    # GET_ONE
    endpoint description: "Get ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer]
      },
      tags: ["ActionTrack"]
    get "/action-tracks/:id" do
      json({:data => [action_track_obj(ActionTrack.get(params[:id]))]})
    end

    # CREATE
    endpoint description: "Create ActionTrack",
      responses: standard_errors( 200 => "ActionTrackResponse"),
      parameters: {
        data: ["ActionTrack", :body, true, "NewActionTrack"]
      },
      tags: ["ActionTrack"]

    post "/action-tracks/?", require_role: :curator do
      fields = params['parsed_body']['data']
      obj_fields = fields.slice(*self.class.EDITABLE_FIELDS).select

      ActionTrack.transaction do |t|
        begin
          ap = ActionTrack.create!(obj_fields)
          action_track_update(ap, fields)
          ap.save!

          json({data: action_track_obj(ap)})
        rescue
          t.rollback
          raise $!
        end
      end
    end

    # UPDATE
    endpoint description: "Update ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer],
        data: ["Data of ActionTrack", :body, true, "ActionTrack"]
      },
      tags: ["ActionTrack"]
    put "/action-tracks/:id/?", require_role: :curator do
      data = params['parsed_body']['data']
      data['id'] = params['id']

      fields = params['parsed_body']['data']
      obj_fields = fields.slice(*self.class.EDITABLE_FIELDS).select

      ActionTrack.transaction do |t|
        begin
          ap = ActionTrack.get(params[:id])
          ap.update(obj_fields)
          action_track_update(ap, fields)
          ap.save!

          json({data: [action_track_obj(ap)]})
        rescue
          t.rollback
          raise $!
        end
      end
    end

    # UPDATE_MANY
    endpoint description: "Update Many ActionTrack records",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        data: ["Data of ActionTracks", :body, true, ["ActionTrack"]]
      },
      tags: ["ActionTrack"]
    put "/action-tracks/?", require_role: :curator do
      res = params['parsed_body']['data'].map do |fields|
        obj_fields = fields.slice(*self.class.EDITABLE_FIELDS).select

        ActionTrack.transaction do |t|
          begin
            ap = ActionTrack.get(fields[:id])
            ap.update(obj_fields)
            action_track_update(ap, fields)
            ap.save!

            action_track_obj(ap)
          rescue
            t.rollback
            raise $!
          end
        end
      end
      json({:data => res})
    end

    # DELETE
    endpoint description: "Delete ActionTrack record",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        id: ["ID of ActionTrack", :path, true, Integer]
      },
      tags: ["ActionTrack"]
    delete "/action-tracks/:id/?", require_role: :curator do
      ats = [params["id"]].flatten.map do |id|
        at = ActionTrack.get(id)
        if at
          action_track_delete(at)
        end
        at
      end

      json({:data => ats})
    end

    # DELETE_MANY
    endpoint description: "Delete MANY ActionTrack records",
      responses: standard_errors( 200 => "ActionTracksResponse"),
      parameters: {
        ids: ["ID of ActionTrack", :query, true, [Integer]]
      },
      tags: ["ActionTrack"]
    delete "/action-tracks/?", require_role: :curator do
      ats = [params["ids"]].flatten.map do |id|
        at = ActionTrack.get(id)
        if at
          action_track_delete(at)
        end
        at
      end
      json({:data => ats})
    end
  end
end
