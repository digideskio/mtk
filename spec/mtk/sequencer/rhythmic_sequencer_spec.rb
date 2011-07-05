require 'spec_helper'

describe MTK::Sequencer::RhythmicSequencer do

  RHYTHMIC_SEQUENCER = Sequencer::RhythmicSequencer

  let(:pitches)     { Pattern.PitchSequence(C4, D4, E4, C4) }
  let(:intensities) { Pattern.IntensitySequence(0.3, 0.6, 0.9, 1.0) }
  let(:durations)   { Pattern.DurationSequence(1, 1, 2, 1) }
  let(:rhythm)      { Pattern.RhythmSequence(0.5, 1.5, 4) }
  let(:rhythmic_sequencer) { RHYTHMIC_SEQUENCER.new [pitches, durations, intensities, rhythm] }

  describe "#new" do
    it "defaults @max_steps to nil" do
      rhythmic_sequencer.max_steps.should be_nil
    end

    it "sets @max_steps from the options hash" do
      rhythmic_sequencer = RHYTHMIC_SEQUENCER.new [], :max_steps => 4
      rhythmic_sequencer.max_steps.should == 4
    end
  end

  describe "#to_timeline" do
    it "returns a Timeline" do
      rhythmic_sequencer.to_timeline.should be_a Timeline
    end

    it "contains notes assembled from the given patterns" do
      rhythmic_sequencer.to_timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        0.5 => Note(D4,0.6,1),
        2.0 => Note(E4,0.9,2),
        6.0 => Note(C4,1.0,1)
      })
    end
  end

  describe "#max_steps" do
    it "controls the maximum number of times in the generated timeline" do
      rhythmic_sequencer.max_steps = 2
      rhythmic_sequencer.to_timeline.should == Timeline.from_hash({
        0 => Note(C4,0.3,1),
        0.5 => Note(D4,0.6,1)
      })
    end
  end

end