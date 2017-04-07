require 'sidekiq-scheduler'

class ProsoccergrPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []

      doc = Nokogiri::HTML(open("http://www.prosoccer.gr/en/#{Date.today.strftime("%Y/%m")}/soccer-predictions-#{Date.today.strftime("%Y-%m-%d")}.html", "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

      doc.css(".mio.fc1").each do |content|
        p "---------------------------------------------------------------------"
        p content
        p "---------------------------------------------------------------------"

        homeTeam = content.text.split('-').first.strip
        awayTeam = content.text.split('-').last.strip
        homeProbability = content.next_element.text.strip
        drawProbability = content.next_element.next_element.text.strip
        awayProbability = content.next_element.next_element.next_element.text.strip
        over25GoalsProbability = content.parent.children.last.previous_element.previous_element.previous_element.text
        homeScorePredicted = content.parent.children.last.previous_element.previous_element.previous_element.previous_element.previous_element.text.split('-').first
        awayScorePredicted = content.parent.children.last.previous_element.previous_element.previous_element.previous_element.previous_element.text.split('-').last

        if [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == homeProbability.to_i
          bettingPrediction = "1"
        elsif [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == drawProbability.to_i
          bettingPrediction = "X"
        elsif [homeProbability.to_i, drawProbability.to_i, awayProbability.to_i].max == awayProbability.to_i
          bettingPrediction = "2"
        end


         prediction = {
             home_team_id: homeTeam.gsub("\u00A0", ""),
             away_team_id: awayTeam.gsub("\u00A0", ""),
             home_goals_predicted: homeScorePredicted.to_i,
             away_goals_predicted: awayScorePredicted.to_i,
             home_probability: homeProbability.to_i,
             draw_probability: drawProbability.to_i,
             away_probability: awayProbability.to_i,
             over_25_goals_probability: over25GoalsProbability.to_i,
             expert_id: 'prosoccergr',
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
