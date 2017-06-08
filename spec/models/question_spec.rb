require 'spec_helper'

describe Query do
  let!(:exercise) { create(:problem) }
  let(:student) { create(:user) }

  describe '#submit_question!' do
    let(:assignment) { exercise.assignment_for student }

    context 'when just a question on an empty assignment is sent' do
      before { exercise.submit_question!(student, content: 'Please help!') }

      it { expect(assignment.status).to eq Status::Pending }
      it { expect(assignment.result).to be nil }

      it { expect(assignment.solution).to be nil }
      it { expect(exercise.assigned_to? student).to be true }
      it { expect(assignment.messages.count).to eq 1 }
      it { expect(assignment.submission_id).to_not be nil }
    end

    context 'when a question on a previous submission is sent' do
      before do
        assignment = exercise.submit_solution!(student, content: 'x = 1')
        assignment.failed!
        @original_submission_id = assignment.submission_id
      end

      before { exercise.submit_question!(student, content: 'Please help!') }

      it { expect(exercise.assigned_to? student).to be true }
      it { expect(assignment.status).to eq Status::Failed }
      it { expect(assignment.result).to eq 'noop result' }
      it { expect(assignment.solution).to eq 'x = 1' }
      it { expect(assignment.messages.count).to eq 1 }
      it { expect(assignment.submission_id).to eq @original_submission_id }
    end
  end
end
