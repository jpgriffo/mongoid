# encoding: utf-8
module Mongoid #:nodoc:
  module Threaded #:nodoc:

    # This module contains convenience methods for document lifecycle that
    # resides on thread locals.
    module Lifecycle
      extend ActiveSupport::Concern

      private

      # Begin the assignment of attributes. While in this block embedded
      # documents will not autosave themselves in order to allow the document to
      # be in a valid state.
      #
      # @example Execute the assignment.
      #   _assigning do
      #     person.attributes = { :addresses => [ address ] }
      #   end
      #
      # @return [ Object ] The yielded value.
      #
      # @since 2.2.0
      def _assigning
        Threaded.begin_assign
        yield
      ensure
        Threaded.exit_assign
      end

      # Is the current thread in assigning mode?
      #
      # @example Is the current thread in assigning mode?
      #   proxy._assigning?
      #
      # @return [ true, false ] If the thread is assigning.
      #
      # @since 2.1.0
      def _assigning?
        Threaded.assigning?
      end

      # Execute a block in binding mode.
      #
      # @example Execute in binding mode.
      #   binding do
      #     relation.push(doc)
      #   end
      #
      # @return [ Object ] The return value of the block.
      #
      # @since 2.1.0
      def _binding
        Threaded.begin_bind
        yield
      ensure
        Threaded.exit_bind
      end

      # Is the current thread in binding mode?
      #
      # @example Is the current thread in binding mode?
      #   proxy.binding?
      #
      # @return [ true, false ] If the thread is binding.
      #
      # @since 2.1.0
      def _binding?
        Threaded.binding?
      end

      # Execute a block in building mode.
      #
      # @example Execute in building mode.
      #   _building do
      #     relation.push(doc)
      #   end
      #
      # @return [ Object ] The return value of the block.
      #
      # @since 2.1.0
      def _building
        Threaded.begin_build
        yield
      ensure
        Threaded.exit_build
      end

      # Is the current thread in building mode?
      #
      # @example Is the current thread in building mode?
      #   proxy._building?
      #
      # @return [ true, false ] If the thread is building.
      #
      # @since 2.1.0
      def _building?
        Threaded.building?
      end

      # Is the current thread in creating mode?
      #
      # @example Is the current thread in creating mode?
      #   proxy.creating?
      #
      # @return [ true, false ] If the thread is creating.
      #
      # @since 2.1.0
      def _creating?
        Threaded.creating?
      end

      module ClassMethods #:nodoc:

        # Execute a block in creating mode.
        #
        # @example Execute in creating mode.
        #   creating do
        #     relation.push(doc)
        #   end
        #
        # @return [ Object ] The return value of the block.
        #
        # @since 2.1.0
        def _creating
          Threaded.begin_create
          yield
        ensure
          Threaded.exit_create
        end
      end
    end
  end
end