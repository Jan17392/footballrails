class PredictionJob < ApplicationJob
  queue_as :default

  def perform(predictions)

    predictions.each do |prediction|

      starts = prediction[:date].to_datetime - 1
      ends = starts + 2

      home_id = TeamMapping.where(prediction[:expert_id].downcase => prediction[:home_team_id].downcase).first
      away_id = TeamMapping.where(prediction[:expert_id].downcase => prediction[:away_team_id].downcase).first
      prediction[:match_id] = Match.where(home_team_id: home_id).where(away_team_id: away_id).where(date: starts..ends).first
      prediction[:expert_id] = Expert.where(name: prediction[:expert_id].downcase).first
      existing_prediction = Prediction.where(match_id: prediction[:match_id]).where(expert_id: prediction[:expert_id]).first

      if !home_id.nil? && !away_id.nil? && !prediction[:match_id].nil? && existing_prediction.nil?
          puts "========================"
          puts "PREPARING TO CREATE NEW PREDICTION !!!!"
          puts "========================"
          prediction[:expert_id] = prediction[:expert_id][:id]
          prediction[:match_id] = prediction[:match_id][:id]

          newprediction = Prediction.new(
            match_id: prediction[:match_id],
            expert_id: prediction[:expert_id],
            home_probability: prediction[:home_probability],
            draw_probability: prediction[:draw_probability],
            away_probability: prediction[:away_probability],
            home_goals_predicted: prediction[:home_goals_predicted],
            away_goals_predicted: prediction[:away_goals_predicted],
            winner_predicted: prediction[:winner_predicted],
            home_probability_halftime: prediction[:home_probability_halftime],
            draw_probability_halftime: prediction[:draw_probability_halftime],
            away_probability_halftime: prediction[:away_probability_halftime],
            over_15_goals_probability: prediction[:over_15_goals_probability],
            over_25_goals_probability: prediction[:over_25_goals_probability],
            over_35_goals_probability: prediction[:over_35_goals_probability]
          )

          newprediction.save
      end
    end
  end
end
