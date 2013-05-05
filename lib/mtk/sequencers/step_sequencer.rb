module MTK
  module Sequencers

    # A Sequencer which has a constant {#step_size} time between {Timeline} entries.
    class StepSequencer < Sequencer

      # The time between entries in the {Timeline}.
      attr_accessor :step_size

      def initialize(patterns, options={})
        super
        @step_size = options.fetch :step_size, 1
      end

     ########################
      protected

      # (see Sequencer#advance!)
      def advance!
        @time += @step_size
      end

    end


    # Construct a {StepSequencer} from any supported type
    def StepSequencer(*args)
      options  = (args[-1].is_a? Hash) ? args.pop : {}
      patterns = (args.length==1 and args[0].is_a? Array) ? args[0] : args
      StepSequencer.new(patterns,options)
    end
    module_function :StepSequencer

  end
end
