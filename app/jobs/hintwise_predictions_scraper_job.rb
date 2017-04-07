require 'sidekiq-scheduler'

class HintwisePredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []
    urls = []

    doc = Nokogiri::HTML(open("http://hintwise.com/index?date=#{Date.today.strftime("%Y-%m-%d")}"), nil, 'utf-8')

    doc.css(".cellTEAMS").each do |content|
      url = content.children.first.children.attr('href').value
      urls << url
    end

    urls.each do |url|

      container = []

      doc2 = Nokogiri::HTML(open("http://hintwise.com/#{url}"), nil, 'utf-8')

      doc2.css(".progress-bar").each do |content|

        # Store all six progress bar elements, but only use the first three
        container << content

      end

      homeTeam = container[0].text.split('(').first.strip
      homeProbability = container[0].text.split('(').last.strip.gsub(")", "").gsub("%", "")
      drawProbability = container[1].text.split('(').last.strip.gsub(")", "").gsub("%", "")
      awayTeam = container[2].text.split('(').first.strip
      awayProbability = container[2].text.split('(').last.strip.gsub(")", "").gsub("%", "")

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
           expert_id: 'hintwise',
           date: Date.today.strftime("%d.%m.%Y"),
           winner_predicted: bettingPrediction
         }

      predictions << prediction

      p prediction

    end

  p predictions
  p "--------------- STARTING JOB ----------------"
  PredictionJob.perform_later(predictions)
  end
end
