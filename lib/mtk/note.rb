module MTK

  # A musical {Event} defined by a {Pitch}, intensity, and duration
  class Note < Event

    # frequency of the note as a Pitch
    attr_reader :pitch

    def initialize(pitch, intensity, duration)
      @pitch = pitch
      super(intensity, duration)
    end

    def self.from_hash(hash)
      new hash[:pitch], hash[:intensity], hash[:duration]
    end

    def self.from_midi(pitch, velocity, beats)
      new Pitches::PITCHES[pitch], velocity/127.0, beats
    end

    def to_hash
      super.merge({ :pitch => @pitch })
    end

    def transpose(interval)
      self.class.new(@pitch+interval, @intensity, @duration)
    end

    def == other
      super and other.respond_to? :pitch and @pitch == other.pitch
    end

    def to_s
      "Note(#{pitch}, #{super})"
    end

    def inspect
      "Note(#{pitch}, #{super})"
    end

  end

end
