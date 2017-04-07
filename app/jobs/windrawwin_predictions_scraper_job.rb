require 'sidekiq-scheduler'

class WindrawwinPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    urls = [
      "http://www.windrawwin.com/predictions/today/simple/england-cup-international/all-stakes/all-venues/",
      "http://www.windrawwin.com/predictions/today/simple/major-european/all-stakes/all-venues/",
      "http://www.windrawwin.com/predictions/today/simple/uk-and-ireland/all-stakes/all-venues/",
      "http://www.windrawwin.com/predictions/today/simple/rest-of-europe/all-stakes/all-venues/"
    ]

    predictions = []

    urls.each do |url|
      p url
      doc = Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

      doc.css(".fixt").each do |content|

        homeTeam = content.text.split(' v ').first.strip
        awayTeam = content.text.split(' v ').last.strip
        homeScorePredicted = content.parent.children.last.text.split('-').first
        awayScorePredicted = content.parent.children.last.text.split('-').last

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
            expert_id: 'windrawwin',
            date: Date.today.strftime("%d.%m.%Y"),
            winner_predicted: winner_predicted
        }

        predictions << prediction

        p prediction
    end
  end
  p "--------------- STARTING JOB ----------------"
  PredictionJob.perform_later(predictions)
  end
end
