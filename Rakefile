
require 'inquirer'

namespace :db do
  task :migrate do
    require './app.rb'
    DataMapper.auto_upgrade!
  end
  task :hard_migrate do
    require './app.rb'
    puts CONFIG
    DataMapper.auto_migrate!
  end
  task :load, [:file] do |t, args|
    require './app.rb'
    require 'csv'

    Thread.current[:user_id] = -1
    # Delete all the existing records
    ActionTrack.all.each do |at|
      at.action_types = []
      at.partners = []
      at.funding_sources = []
      at.shmcap_goals = []
      at.primary_climate_interactions = []
      at.save!
      at.destroy!
    end

    ActionStatus.all.map(&:destroy)
    ActionType.all.map(&:destroy)
    AgencyPriority.all.map(&:destroy)
    CompletionTimeframe.all.map(&:destroy)
    ExecOffice.all.map(&:destroy)
    FundingSource.all.map(&:destroy)
    GlobalAction.all.map(&:destroy)
    LeadAgency.all.map(&:destroy)
    Partner.all.map(&:destroy)
    PrimaryClimateInteraction.all.map(&:destroy)
    ProgressNote.all.map(&:destroy)
    ShmcapGoal.all.map(&:destroy)
    count = 0
    CSV.read(args.file, headers: true).each do |row|
      count += 1
      at = ActionTrack.new(title: row["Title"],
                           description: row["Description"],
                           public: true)
      # Timeframe
      compl_timeframe = CompletionTimeframe.first(:timeframe => row["Completion Timeframe"])
      if not compl_timeframe
        compl_timeframe = CompletionTimeframe.create!(:timeframe => row["Completion Timeframe"])
      end
      at.completion_timeframe = compl_timeframe

      # Action Status
      action_status = ActionStatus.first(:status => row["Action Status"])
      if not action_status
        action_status = ActionStatus.create!(:status => row["Action Status"])
      end
      at.action_status = action_status

      # Exec Office
      exec_office = ExecOffice.first(:name => row["Executive Office"])
      if not exec_office
        exec_office = ExecOffice.create!(:name => row["Executive Office"])
      end
      at.exec_office = exec_office

      # Lead Agency
      lead_agency = LeadAgency.first(:name => row["Lead Agency"])
      if not lead_agency
        lead_agency = LeadAgency.create!(:name => row["Lead Agency"])
      end
      at.lead_agency = lead_agency

      # Agency Priority
      agency_priority = AgencyPriority.first(:name => row["Agency Priority"])
      if not agency_priority
        agency_priority = AgencyPriority.create!(:name => row["Agency Priority"])
      end
      at.agency_priority = agency_priority

      # Global Action
      # Not in the dump

      # Progress Notes
      if row["Progress Notes"] && row["Progress Notes"] != ""
        progress_note = ProgressNote.first(:note => row["Progress Notes"])
        if not progress_note
          progress_note = ProgressNote.new(:note => row["Progress Notes"])
        end
        at.progress_notes = [progress_note]
      end

      # Action Type
      # Not in the dump

      # Partners
      partners = (row["Possible Partners"] || "").split(',').map do |pname|
        Partner.first(:name => pname) or
          Partner.create!(:name => pname)
      end
      at.partners = partners

      # Possible Funding Sources
      funding_sources = (row["Possible funding source(s)"] || "").split(',').map do |fsname|
        FundingSource.first(:name => fsname) or
          FundingSource.create!(:name => fsname)
      end
      at.funding_sources = funding_sources

      # Shmcap Goals
      goals = (row["SHMCAP Goals"] || "").split(',').map do |goal|
        ShmcapGoal.first(:name => goal) or
          ShmcapGoal.create!(:name => goal)
      end
      at.shmcap_goals = goals

      # Primary Climate Interactions
      interactions = (row["Primary Climate Interactions"] || "").split(',').map do |interaction|
        PrimaryClimateInteraction.first(:name => interaction) or
          PrimaryClimateInteraction.create!(:name => interaction)
      end
      at.primary_climate_interactions = interactions
      at.save!
    end
    puts("Count: ", count)
    puts("In DB:", ActionTrack.count)
  end
end
namespace :users do
  task :list do
    users = User.find
    users.each do |user|
      puts user.attributes
    end
  end

  task :delete, [:id] do |t, args|
    user = User.get(args.id)
    if user && user.destroy
      puts "Deleted user"
    else
      puts "Failed to delete"
    end

  end

  task :create do |t, args|
    user = User.new
    user.username = Ask.input "Username"
    user.password = Ask.input("Password", password: true)
    user.name     = Ask.input "Name"
    user.email    = Ask.input "Email"
    user.roles    = [User::ROLES[Ask.list("Role", User::ROLES)]]

    if user.save
      puts "Created user:"
      puts user.attributes
    else
      puts "Failed to create: "
      puts user.errors.full_messages.join("\n")
    end
  end

  task :update_password do |t, args|
    username = Ask.input "Username"
    user = User.first(username: username)
    user.password = Ask.input("Password", password: true)

    if user.save
      puts "updated user:"
      puts user.attributes
    else
      puts "Failed to update: "
      puts user.errors.full_messages.join("\n")
    end
  end
end
