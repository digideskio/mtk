module MTK

  # A frequency represented by a {PitchClass}, an integer octave, and an offset in semitones.
  
  class Pitch

    include Comparable

    attr_reader :pitch_class, :octave, :offset

    def initialize( pitch_class, octave, offset=0 )
      @pitch_class, @octave, @offset = pitch_class, octave, offset
      @value = @pitch_class.to_i + 12*(@octave+1) + @offset
    end
    
    def self.from_s( s )
      # TODO: update to handle offset
      s = s[0].upcase + s[1..-1].downcase # normalize name
      if s =~ /^([A-G](#|##|b|bb)?)(-?\d+)$/
        pitch_class = PitchClass.from_s($1)
        if pitch_class
          octave = $3.to_i
          new( pitch_class, octave )
        end
      end
    end
    
    # Convert a Numeric semitones value into a Pitch
    def self.from_f( f )
      i, offset = f.floor, f%1  # split into int and fractional part
      pitch_class = PitchClass.from_i(i)
      octave = i/12 - 1
      new( pitch_class, octave, offset )      
    end      
    
    # Convert a Numeric semitones value into a Pitch    
    def self.from_i( i )
      from_f( i )
    end

    # The numerical value of this pitch
    def to_f
      @value
    end 

    # The numerical value for the nearest semitone
    def to_i
      @value.round
    end
    
    def offset_in_cents
      @offset * 100
    end
    
    def to_s
      "#{@pitch_class}#{@octave}" + (@offset.zero? ? '' : "+#{offset_in_cents}cents")
    end
    
    def ==( other )
      other.respond_to? :pitch_class and other.respond_to? :octave and other.respond_to? :offset and
      other.pitch_class == @pitch_class and other.octave == @octave and other.offset == @offset
    end

    def <=> other
      @value <=> other.to_f
    end

    def + interval_in_semitones
     self.class.from_f( @value + interval_in_semitones.to_f )
    end

    def - interval_in_semitones
      self.class.from_f( @value - interval_in_semitones.to_f )
    end

    def % interval_in_semitones
      self.class.from_f( @value + interval_in_semitones.to_f )
    end

    def coerce(other)
      return self.class.from_f(other.to_f), self
    end

    # Defines a constants for each {Pitch} in the standard MIDI range using scientific pitch notation.
    #
    # See http://en.wikipedia.org/wiki/Scientific_pitch_notation
    #
    # Note that because the character '#' cannot be used in the name of a constant,
    # The "black key" pitches are all named as flats with 'b' (for example, Gb3 or Cb4)
    module Constants
      # An array of all the pitch constants defined in this module
      PITCHES = []

      128.times do |note_number|
        pitch = Pitch.from_i( note_number )
        PITCHES << pitch
        const_name = pitch.to_s.sub(/-/,'_') # '_1' for -1
        const_set const_name, pitch
      end
    end

  end

end
