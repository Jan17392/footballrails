require 'sidekiq-scheduler'

class PropredictionsPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    urls = [
      'http://premierleague.propredictions.eu/',
      'http://bundesliga.propredictions.eu/',
      'http://primera.propredictions.eu/',
      'http://seriea.propredictions.eu/',
      'http://ligue1.propredictions.eu/'
    ]

    predictions = []

    urls.each do |url|

      doc = Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

      doc.css("tr").each do |content|

        if content.next_element
          homeTeam = content.next_element.children.first.next_element.next_element.next_element.children.children.children.text.split(' - ').first
          awayTeam = content.next_element.children.first.next_element.next_element.next_element.children.children.children.text.split(' - ').last
          homeScorePredicted = content.next_element.children.first.next_element.next_element.next_element.next_element.children.children.children.text.split(':').first
          awayScorePredicted = content.next_element.children.first.next_element.next_element.next_element.next_element.children.children.children.text.split(':').last
          goalDifference = homeScorePredicted.to_i - awayScorePredicted.to_i

          if goalDifference == 0
            homeProbability = 30
            drawProbability = 40
            awayProbability = 30
            winner_predicted = "X"
          elsif goalDifference > 0
            homeProbability = (goalDifference * goalDifference)/(goalDifference + 1) * 10 + 50
            drawProbability = (100 - homeProbability) / 1.33
            awayProbability = 100 - homeProbability - drawProbability
            winner_predicted = "1"
          elsif goalDifference < 0
            awayProbability = (goalDifference * goalDifference)/(goalDifference * (-1) + 1) * 10 + 50
            drawProbability = (100 - awayProbability) / 1.33
            homeProbability = 100 - awayProbability - drawProbability
            winner_predicted = "2"
          end

          prediction = {
            home_team_id: homeTeam,
            away_team_id: awayTeam,
            home_goals_predicted: homeScorePredicted.to_i,
            away_goals_predicted: awayScorePredicted.to_i,
            home_probability: homeProbability.to_i,
            draw_probability: drawProbability.to_i,
            away_probability: awayProbability.to_i,
            expert_id: 'proprediction',
            date: Date.today.strftime("%d.%m.%Y"),
            winner_predicted: winner_predicted
          }

          predictions << prediction

          p prediction
        end
    end
  end
  p "--------------- STARTING JOB ----------------"
  PredictionJob.perform_later(predictions)
  end
end
