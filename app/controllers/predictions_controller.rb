class PredictionsController < ApplicationController
  def index
    @predictions = Prediction.all
    render json: @predictions
  end

  def show
    if Prediction.exists?(params[:id])
      @prediction = Prediction.find(params[:id])
      render json: @prediction
    else
      render(:file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 403, :layout => false)
    end
  end

  def update
  end

  def delete
  end

  def create
    data = params[:predictions]
    predictions = data.to_a

    PredictionJob.perform_later(predictions: predictions)

    render json: {}, status: :ok
  end

  def prediction_params
    params.require(:prediction).permit(
      :match_id,
      :expert_id,
      :home_probability,
      :draw_probability,
      :away_probability,
      :home_goals_predicted,
      :away_goals_predicted,
      :winner_predicted,
      :home_probability_halftime,
      :draw_probability_halftime,
      :away_probability_halftime,
      :over_15_goals_probability,
      :over_25_goals_probability,
      :over_35_goals_probability
      )
  end
end
