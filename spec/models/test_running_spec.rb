require 'spec_helper'

describe TestRunning do

  describe '#perform' do
    let(:exercise) { create(:exercise) }
    before { submission.run_tests! }

    context 'when submission is ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to eq(:passed) }
      it { expect(submission.reload.result).to eq('TODO') }
    end

    context 'when submission is not ok' do
      let(:submission) { exercise.submissions.create! }
      it { expect(submission.reload.status).to eq(:failed) }
      it { expect(submission.reload.result).to eq('TODO') }
    end

  end
end