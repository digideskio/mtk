require 'mtk'
require 'mtk/helpers/output_selector'
include MTK
include Constants::Pitches

output = Helpers::OutputSelector.ensure_output ARGV[0]

output.play Note(C4,1,2)