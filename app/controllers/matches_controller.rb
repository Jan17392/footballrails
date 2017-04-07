class MatchesController < ApplicationController
  def index
    @matches = Match.joins(:predictions).distinct
  end

  # Method to expose all unfinished matches to NodeJS to update them regularly
  def recent_matches
    @matches = Match.where(status: nil);
    render json: { matches: @matches }, status: :ok
  end

  # Return all Matches which have a Referencer for Odds, but no Odds yet
  def matches_without_odds
    @matches = Match.includes(:odds).where(odds: { match_id: nil }).where.not(match_referencer: nil)
    render json: { matches: @matches }, status: :ok
  end

  def show
  end

  def update
  end

  def delete
  end

  # Assemble Training Method is to create a training spreadsheet with all
  # relevant features for Microsoft Azure Machine Learning Models
  def assemble_training
    # Load all Matches
    matches = Match.all

    # For each Match check whether Odds and Predictions exist
    matches.each do |match|
      predictions = Prediction.where(match: match)
      odds = Odd.where(match: match)

      # If Odds and Predictions exist, calculate min, max, avg, etc for each
      if predictions.count > 0 && odds.count > 0 && match.home_goals && match.away_goals

        odds_home_average = odds.average(:home_odd)
        odds_draw_average = odds.average(:draw_odd)
        odds_away_average = odds.average(:away_odd)

        odds_home_max = odds.maximum(:home_odd)
        odds_draw_max = odds.maximum(:draw_odd)
        odds_away_max = odds.maximum(:away_odd)

        odds_home_min = odds.minimum(:home_odd)
        odds_draw_min = odds.minimum(:draw_odd)
        odds_away_min = odds.minimum(:away_odd)

        predictions_count = predictions.count

        predictions_home_average = predictions.average(:home_probability)
        predictions_draw_average = predictions.average(:draw_probability)
        predictions_away_average = predictions.average(:away_probability)

        predictions_home_max = predictions.maximum(:home_probability)
        predictions_draw_max = predictions.maximum(:draw_probability)
        predictions_away_max = predictions.maximum(:away_probability)

        predictions_home_min = predictions.minimum(:home_probability)
        predictions_draw_min = predictions.minimum(:draw_probability)
        predictions_away_min = predictions.minimum(:away_probability)

        winner = match.home_goals - match.away_goals
        # TODO: Add standard deviaton calculation for odds and predictions
        # Include expert quality score to weight the predictions

        # Write all Data with append to the training file
        CSV.open("csv_input/assemble_training.csv", "ab") do |csv|
          csv << [
            match.id,
            match.home_team_id,
            match.away_team_id,
            winner,
            # I need the Outcome of the Game to improve the ML Algo
            # As Difference of Goals?
            # As Winner?
            # As Percentage (of what though)?

            odds_home_average,
            odds_draw_average,
            odds_away_average,
            odds_home_max,
            odds_draw_max,
            odds_away_max,
            odds_home_min,
            odds_draw_min,
            odds_away_min,
            predictions_count,
            predictions_home_average,
            predictions_draw_average,
            predictions_away_average,
            predictions_home_max,
            predictions_draw_max,
            predictions_away_max,
            predictions_home_min,
            predictions_draw_min,
            predictions_away_min
          ]
        end
      end
    end
  end

    # Assemble Training Method is to create a training spreadsheet with all
  # relevant features for Microsoft Azure Machine Learning Models
  def assemble_expert_performance
    # Load all Matches
    matches = Match.all
    expert = Expert.where(name: "zulubet").first().id

    # For each Match check whether Odds and Predictions exist
    matches.each do |match|
      predictions = Prediction.where(match: match).where(expert_id: expert).first()
      odds = Odd.where(match: match)

      # If Odds and Predictions exist, calculate min, max, avg, etc for each
      if predictions && odds.count > 0 && match.home_goals && match.away_goals

        odds_home_average = odds.average(:home_odd)
        odds_draw_average = odds.average(:draw_odd)
        odds_away_average = odds.average(:away_odd)

        odds_home_max = odds.maximum(:home_odd)
        odds_draw_max = odds.maximum(:draw_odd)
        odds_away_max = odds.maximum(:away_odd)

        odds_home_min = odds.minimum(:home_odd)
        odds_draw_min = odds.minimum(:draw_odd)
        odds_away_min = odds.minimum(:away_odd)

        predictions_home = predictions.home_probability
        predictions_draw = predictions.draw_probability
        predictions_away = predictions.away_probability

        winner = match.home_goals - match.away_goals
        # TODO: Add standard deviaton calculation for odds and predictions
        # Include expert quality score to weight the predictions

        # Write all Data with append to the training file
        CSV.open("csv_input/assemble_expert_performance.csv", "ab") do |csv|
          csv << [
            winner,
            # I need the Outcome of the Game to improve the ML Algo
            # As Difference of Goals?
            # As Winner?
            # As Percentage (of what though)?

            odds_home_average,
            odds_draw_average,
            odds_away_average,
            odds_home_max,
            odds_draw_max,
            odds_away_max,
            odds_home_min,
            odds_draw_min,
            odds_away_min,
            predictions_home,
            predictions_draw,
            predictions_away,
          ]
        end
      end
    end
  end


  # Create new Matches from NodeJS via API
  def create
    # Read the Matches from the JSON Object
    data = params[:matches]
    matches = data.to_a

    MatchCreatorJob.perform_later(matches: matches)

    render json: {}, status: :ok

  end

  def matches_params
    params.require(:match).permit(
      :home_team_id,
      :date,
      :away_team_id,
      :home_goals,
      :away_goals,
      :status,
      :home_goals_first_half,
      :away_goals_first_half,
      :home_goals_second_half,
      :away_goals_second_half,
      :match_url,
      :match_referencer
      )
  end
end
