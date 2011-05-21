require 'spec_helper'

describe MTK::Note do

  let(:pitch) { C4 }
  let(:intensity) { mf }
  let(:duration) { 2.5 }
  let(:note) { Note.new(pitch, intensity, duration) }

  describe "from_hash" do
    it "constructs a Note using a hash" do
      Note.from_hash({ :pitch => C4, :intensity => intensity, :duration => duration }).should == note
    end
  end

  describe 'from_midi' do
    it "constructs a Note using a MIDI pitch and velocity" do
      Note.from_midi(C4.to_i, mf*127, 2.5).should == note
    end
  end

  describe "to_hash" do
    it "is a hash containing all the attributes of the Note" do
      note.to_hash.should == { :pitch => pitch, :intensity => intensity, :duration => duration }
    end
  end

  describe '#transpose' do
    it 'adds the given interval to the @pitch' do
      (note.transpose 2.semitones).should == Note.new(D4, intensity, duration)
    end
    it 'does not affect the immutability of the Note' do
      (note.transpose 2.semitones).should_not == note
    end
  end

  describe "#==" do
    it "is true when the pitches, intensities, and durations are equal" do
      note.should == Note.new(pitch, intensity, duration)
    end

    it "is false when the pitches are not equal" do
      note.should_not == Note.new(pitch + 1, intensity, duration)
    end

    it "is false when the intensities are not equal" do
      note.should_not == Note.new(pitch, intensity * 0.5, duration)
    end

    it "is false when the durations are not equal" do
      note.should_not == Note.new(pitch, intensity, duration * 2)
    end
  end

end
