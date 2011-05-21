require 'rubygems'
require 'midilib'
MIDILIB = MIDI unless defined? MIDILIB # helps distinguish MTK::MIDI from midilib's MIDI, and avoids a JRuby-1.5 bug with module name collision

module MTK
  module MIDI

    # Reads a MIDI file into a {Timeline}.
    #
    # Requires the midilib gem (https://github.com/jimm/midilib)
    #
    class FileReader

      # Reads the file into a {Timeline}
      #
      # @param filepath [String, #path] path of the file to be written
      # @return [Timeline]
      #
      def read(filepath)
        @file = filepath
        @file = @file.path if @file.respond_to? :path

        timelines = []

        File.open(@file, 'rb') do |file|
          @sequence = MIDILIB::Sequence.new
          @sequence.read(file)

          track_idx = 0
          notes = {}
          @sequence.each do |track|
            #puts "TRACK #{track_idx}"
            timeline = Timeline.new :autocreate => true

            track.each do |event|
              #puts "#{event.class}: #{event} (#{event.time_from_start})"

              case event
                when MIDILIB::NoteOn
                  notes[event.note] = event

                when MIDILIB::NoteOff
                  if (on_event = notes.delete event.note)
                    duration = (event.time_from_start - on_event.time_from_start)/pulses_per_beat
                    note = Note.from_midi(event.note, on_event.velocity, duration)
                    start_time = (on_event.time_from_start)/pulses_per_beat
                    timeline[start_time] << note
                  end

              end
            end

            timelines << timeline
            track_idx += 1
          end
        end

        timelines
      end

      ########################
      private

      def pulses_per_beat
        @sequence.ppqn.to_f
      end

    end

  end
end
