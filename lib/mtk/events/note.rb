module MTK

  module Events

    # A musical {Event} defined by a {Core::Pitch}, {Core::Intensity}, and {Core::Duration}
    class Note < Event

      DEFAULT_DURATION  = MTK::Core::Duration[1]
      DEFAULT_INTENSITY = MTK::Core::Intensity[0.75]

      # Frequency of the note as a {Pitch}.
      alias :pitch :number
      alias :pitch= :number=

      # Intensity of the note as a value in the range 0.0 - 1.0.
      alias :intensity :value
      alias :intensity= :value=

      # intensity scaled to the MIDI range 0-127
      alias :velocity :midi_value
      alias :velocity= :midi_value=

      def initialize(pitch, duration=DEFAULT_DURATION, intensity=DEFAULT_INTENSITY, channel=nil)
        super :note, number:pitch, duration:duration, value:intensity, channel:channel
      end

      def self.from_h(hash)
        new(hash[:pitch]||hash[:number], hash[:duration], hash[:intensity]||hash[:value], hash[:channel])
      end

      def to_h
        super.merge({ pitch: @number, intensity: @value })
      end

      def self.from_midi(pitch, velocity, duration_in_beats, channel=0)
        new( MTK::Lang::Pitches::PITCHES[pitch.to_i], MTK::Core::Duration[duration_in_beats], MTK::Core::Intensity[velocity/127.0], channel )
      end

      def midi_pitch
        pitch.to_i
      end

      def transpose(interval)
        self.pitch += interval
        self
      end

      def invert(around_pitch)
        self.pitch = self.pitch.invert(around_pitch)
        self
      end

      def ==(other)
        ( other.respond_to? :pitch and pitch == other.pitch and
          other.respond_to? :intensity and intensity == other.intensity and
          other.respond_to? :duration and duration == other.duration
        ) or super
      end

      def to_s
        "Note(#{@number}, #{@duration}, #{@value.to_percent}%)"
      end

      def inspect
        "#<#{self.class}:#{object_id} @pitch=#{@number.inspect}, @duration=#{@duration.inspect}, @intensity=#{@value.inspect}>"
      end

    end
  end

  # Construct a {Events::Note} from a list of any supported type for the arguments: pitch, intensity, duration, channel
  def Note(*anything)
    anything = anything.first if anything.size == 1
    case anything
      when MTK::Events::Note then anything

      when MTK::Core::Pitch then MTK::Events::Note.new(anything)

      when Array
        pitch = nil
        duration = nil
        intensity = nil
        channel = nil
        unknowns = []
        anything.each do |item|
          case item
            when MTK::Core::Pitch then pitch = item
            when MTK::Core::Duration then duration = item
            when MTK::Core::Intensity then intensity = item
            else unknowns << item
          end
        end

        pitch = MTK.Pitch(unknowns.shift) if pitch.nil? and not unknowns.empty?
        raise "MTK::Note() couldn't find a pitch in arguments: #{anything.inspect}" if pitch.nil?

        duration  = MTK.Duration(unknowns.shift)  if duration.nil?  and not unknowns.empty?
        intensity = MTK.Intensity(unknowns.shift) if intensity.nil? and not unknowns.empty?
        channel = unknowns.shift.to_i if channel.nil? and not unknowns.empty?

        duration  ||= MTK::Events::Note::DEFAULT_DURATION
        intensity ||= MTK::Events::Note::DEFAULT_INTENSITY

        MTK::Events::Note.new( pitch, duration, intensity, channel )

      else
        raise "MTK::Note() doesn't understand #{anything.class}"
    end
  end
  module_function :Note

end
