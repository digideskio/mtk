module MTK
  module Constants

    # Defines a constant for intervals up to an octave using diatonic naming conventions (see http://en.wikipedia.org/wiki/Interval_(music)#Main_intervals)
    #
    # Naming conventions
    #   P#: perfect interval
    #   M#: major interval
    #   m#: minor interval
    #   TT: tritone (AKA augmented 4th or diminshed 5th)
    #
    # These can be thought of like constants, but in order to succintly distinguish 'm2' (minor) from 'M2' (major),
    # it was necessary to use lower-case names for some of the values and therefore define them as "pseudo constant" methods.
    # The methods are available either through the module (MTK::Intervals::m2) or via mixin (include MTK::Intervals; m2)
    module Intervals
      extend Helpers::PseudoConstants

      # NOTE: the yard doc macros here only fill in [$2] with the actual value when generating docs under Ruby 1.9+

      # perfect unison
      # @macro [attach] interval.define_constant
      #   @attribute [r]
      #   @return [$2] number of semitones in the interval $1
      define_constant 'P1', MTK::Interval[0]

      # minor second
      # @macro [attach] interval.define_constant
      #   @attribute [r]
      #   @return [$2] number of semitones in the interval $1
      define_constant 'm2', MTK::Interval[1]

      # major second
      define_constant 'M2', MTK::Interval[2]

      # minor third
      define_constant 'm3', MTK::Interval[3]

      # major third
      define_constant 'M3', MTK::Interval[4]

      # pefect fourth
      define_constant 'P4', MTK::Interval[5]

      # tritone (AKA augmented fourth or diminished fifth)
      define_constant 'TT', MTK::Interval[6]

      # perfect fifth
      define_constant 'P5', MTK::Interval[7]

      # minor sixth
      define_constant 'm6', MTK::Interval[8]

      # major sixth
      define_constant 'M6', MTK::Interval[9]

      # minor seventh
      define_constant 'm7', MTK::Interval[10]

      # major seventh
      define_constant 'M7', MTK::Interval[11]

      # pefect octave
      define_constant 'P8', MTK::Interval[12]

      # The values of all "psuedo constants" defined in this module
      INTERVALS = [P1, m2, M2, m3, M3, P4, TT, P5, m6, M6, m7, M7, P8].freeze

      # The names of all "psuedo constants" defined in this module
      INTERVAL_NAMES = MTK::Interval::NAMES

    end
  end
end
