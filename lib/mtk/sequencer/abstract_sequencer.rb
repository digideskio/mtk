module MTK
  module Sequencer

    # A Sequencer produces {Timeline}s from a collection of {Pattern}s.
    #
    # @abstract Subclass and override {#advance} to implement a Sequencer.
    #
    class AbstractSequencer

      # The maximum number of [time,event_list] entries that will be generated for the {Timeline}.
      # nil means no maximum (be careful of infinite loops!)
      attr_accessor :max_steps

      # The maximum time (key) that will be generated for the {Timeline}.
      # nil means no maximum (be careful of infinite loops!)
      attr_accessor :max_time

      # Used by {#to_timeline} to builds event lists from the results of #{Pattern::Enumerator#next} for the {Pattern}s in this Sequencer.
      attr_reader :event_builder

      # The current time offset for the sequencer. Used for the {Timeline} times.
      attr_reader :time

      # The current sequencer step index (the number of times-1 that {#next} has been called), or -1 if the sequencer has not yet started.
      attr_reader :step

      def initialize(patterns, options={})
        @patterns = patterns
        @max_steps = options[:max_steps]
        @max_time = options[:max_time]

        event_builder_class = options.fetch :event_builder, Helper::EventBuilder
        @event_builder = event_builder_class.new(patterns, options)
        rewind
      end


      # Produce a {Timeline} from the {Pattern}s in this Sequencer.
      def to_timeline
        rewind
        timeline = Timeline.new
        loop do
          events = self.next
          timeline[@time] = events if events
        end
        timeline
      end


      # Advanced the step index and time, and return the next list of events built from the sequencer patterns.
      # @note this is called automatically by {#to_timeline},
      #    so you can ignore this method unless you want to hack on sequencers at a lower level.
      def next
        if @step >= 0
          advance!
          raise StopIteration if @max_time and @time > @max_time
        end
        @step += 1
        raise StopIteration if @max_steps and @step >= @max_steps
        @event_builder.next_events
      end


      # Reset the sequencer and all its patterns.
      # @note this is called automatically at the beginning of {#to_timeline},
      #    so you can ignore this method unless you want to hack on sequencers at a lower level.
      def rewind
        @time = 0
        @step = -1
        @patterns.each{|pattern| pattern.rewind }
      end


      ########################
      protected

      # Advance @time to the next time for the {Timeline} being produced by {#to_timeline}
      def advance!
        @time += 1 # default behavior simply advances one beat at a time
      end

    end

  end
end
