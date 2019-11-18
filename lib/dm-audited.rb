require 'rubygems'
gem 'dm-core', '>=0.9.2'
gem 'dm-serializer', '>=0.9.2'
require 'dm-core'
require 'dm-timestamps'
require 'dm-serializer'

module DataMapper
  module Audited
    def self.included(base)
      base.extend(ClassMethods)
    end

    module InstanceMethods

      def create_audit(action)
        # It needs to provide User.current_user if the user is to be saved
        # The implementer needs to provide this and for example needs to make
        # sure that the implementation is thread safe.
        # The request is also optionally included if it can be found in the
        # Application controller. Here again the implementer needs to provide
        # this and make sure it's thread safe.
        user    = Thread.current[:user_id]
        request = defined?(::Application) && ::Application.respond_to?(:current_request)              ? ::Application.current_request : nil

        changed_attributes = {}
        @audited_attributes.each do |key, val|
          changed_attributes[key.name] = [val, attributes[key.name]] unless val == attributes[key.name]
        end

        audit_attributes = {
          :auditable_type => self.class.to_s,
          :auditable_id   => self.id,
          :user_id        => user,
          :action         => action,
          :changes        => changed_attributes,
          :created_at     =>  Time.now
        }

        remove_instance_variable("@audited_attributes")
        remove_instance_variable("@audited_new_record") if instance_variable_defined?("@audited_new_record")

        unless changed_attributes.empty? && action != 'destroy'
          audit = Audit.create!(audit_attributes)
        end
      end

      def audits
        Audit.all(:auditable_type => self.class.to_s, :auditable_id => self.id.to_s, :order => [:created_at, :id])
      end

    end

    module ClassMethods
      def is_audited

        include DataMapper::Audited::InstanceMethods

        before :create do
          @audited_attributes = self.original_attributes.clone
        end

        before :save do
          @audited_attributes = self.original_attributes.clone
        end

        before :destroy do
          @audited_attributes = original_values.clone
        end

        after :create do
          create_audit('create')
        end
        after :save do
          create_audit('update')
        end

        after :destroy do
          create_audit('destroy')
        end

      end
    end

    class Audit
      include DataMapper::Resource

      property :id,             Serial, :key => true
      property :auditable_type, String
      property :auditable_id,   Integer
      property :user_id,        Integer
      property :action,         String
      property :changes,        Object
      property :created_at,     DateTime

      def auditable
        auditable_type.constantize.get(auditable_id)
      end
    end

  end
end
