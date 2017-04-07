class ExpertPerformanceUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    experts = Expert.all

    experts.each do |expert|

      # Get all finished Matches with Predictions from this Expert
      # Check for each Match whether the Prediction of the Expert was right
      # Calculate an accuracy score for this expert

      # Repeat daily and update the field on the expert

      # OR

      # Calculate on each request without the need of a Job?
    end
  end
end
