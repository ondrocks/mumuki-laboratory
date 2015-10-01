class ExerciseAssignmentsController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    guide_previously_done = @exercise.guide_done_for?(current_user)
    @assignment = @exercise.submit_solution(current_user, assignment_params)
    @assignment.run_tests!
    guide_finished_by_solution = !guide_previously_done && @exercise.guide_done_for?(current_user)
    render partial: 'exercise_assignments/results', locals: {assignment: @assignment, guide_finished_by_solution: guide_finished_by_solution}
  end

  private

  def assignment_params
    params.require(:assignment).permit(:content)
  end
end
