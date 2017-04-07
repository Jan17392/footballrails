require 'sidekiq-scheduler'

class StatareaPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []

      doc = Nokogiri::HTML(open("http://statarea.com/predictions/", "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

      doc.css(".hostteam").each do |content|

        homeTeam = content.children.last.previous.text
        awayTeam = content.next_element.children.last.previous.text
        homeProbability = content.parent.parent.next_element.children.children.first.next_element.text
        drawProbability = content.parent.parent.next_element.children.children.first.next_element.next_element.text
        awayProbability = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.text
        homeProbabilityhalftime = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.text
        drawProbabilityhalftime = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.next_element.text
        awayProbabilityhalftime = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.next_element.next_element.text
        over15GoalsProbability = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.next_element.next_element.next_element.text
        over25GoalsProbability = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.next_element.next_element.next_element.next_element.text
        over35GoalsProbability = content.parent.parent.next_element.children.children.first.next_element.next_element.next_element.next_element.next_element.next_element.next_element.next_element.next_element.text

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
              over_15_goals_probability: over15GoalsProbability.to_i,
              over_25_goals_probability: over25GoalsProbability.to_i,
              over_35_goals_probability: over35GoalsProbability.to_i,
              home_probability_halftime: homeProbabilityhalftime.to_i,
              draw_probability_halftime: drawProbabilityhalftime.to_i,
              away_probability_halftime: awayProbabilityhalftime.to_i,
              expert_id: 'statarea',
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
