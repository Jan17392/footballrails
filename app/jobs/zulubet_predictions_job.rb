require 'sidekiq-scheduler'

class ZulubetPredictionsJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []

    doc = Nokogiri::HTML(open("http://www.zulubet.com/tips-#{Date.today.strftime("%d-%m-%Y")}.html"), nil, 'utf-8')

    doc.css(".prob2.aver_odds_min").each do |content|

      homeTeam = content.previous_element.previous_element.previous_element.previous_element.previous_element.previous_element.previous_element.children.last.text.split(' - ').first.strip
      awayTeam = content.previous_element.previous_element.previous_element.previous_element.previous_element.previous_element.previous_element.children.last.text.split(' - ').last.strip
      homeProbability = content.previous_element.previous_element.previous_element.previous_element.previous_element.text
      drawProbability = content.previous_element.previous_element.previous_element.previous_element.text
      awayProbability = content.previous_element.previous_element.previous_element.text

      # Check which team has the highest % to win to get a predicted winner
      if [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == homeProbability.to_i
        bettingPrediction = "1"
      elsif [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == drawProbability.to_i
        bettingPrediction = "X"
      elsif [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == awayProbability.to_i
        bettingPrediction = "2"
      end

      prediction = {
           home_team_id: homeTeam,
           away_team_id: awayTeam,
           home_probability: homeProbability.to_i,
           draw_probability: drawProbability.to_i,
           away_probability: awayProbability.to_i,
           expert_id: 'zulubet',
           date: Date.today.strftime("%d.%m.%Y"),
           winner_predicted: bettingPrediction
      }

      predictions << prediction

      p prediction
  end

  p "--------------- STARTING JOB ----------------"
  PredictionJob.perform_later(predictions)
  end
end
