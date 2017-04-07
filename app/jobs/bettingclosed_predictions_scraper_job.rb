require 'sidekiq-scheduler'
require 'open-uri'

class BettingclosedPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []

    doc = JSON.load(open("https://www.bettingclosed.com/predictions/date-matches/#{Date.today.strftime("%Y-%m-%d")}//bet-type/correct-scores?format=raw&firstLoad=TRUE"))
    p doc

    doc['data'][0]['rows'].each do |row|

      homeTeam = row['teamHomeExt']
      homeScore = row['predScoreHome']
      awayScore = row['predScoreAway']
      awayTeam = row['teamAwayExt']
      #date = DateTime.new(row['dateMatchTZ'])
      #matchDate = date.strftime.("%d.%m.%Y")
      bettingType = row['type']

      if homeScore.to_i - awayScore.to_i == 0
        homeProbability = 30
        drawProbability = 40
        awayProbability = 30
        bettingPrediction = "X"
      elsif homeScore.to_i - awayScore.to_i > 0
        homeProbability = 30 + (homeScore.to_i - awayScore.to_i) * 15
        drawProbability = 40 - (homeScore.to_i - awayScore.to_i) * 7.5
        awayProbability = 30 - (homeScore.to_i - awayScore.to_i) * 7.5
        bettingPrediction = "1"
      elsif homeScore.to_i - awayScore.to_i < 0
        homeProbability = 30 + (homeScore.to_i - awayScore.to_i) * 7.5
        drawProbability = 40 + (homeScore.to_i - awayScore.to_i) * 7.5
        awayProbability = 30 - (homeScore.to_i - awayScore.to_i) * 15
        bettingPrediction = "2"
      end

      prediction = {
        home_team_id: homeTeam,
        away_team_id: awayTeam,
        home_probability: homeProbability.to_i,
        draw_probability: drawProbability.to_i,
        away_probability: awayProbability.to_i,
        bettingPrediction: bettingPrediction,
        home_goals_predicted: homeScore,
        away_goals_predicted: awayScore,
        expert_id: 'bettingclosed',
        date: Date.today.strftime("%d.%m.%Y"),
        winner_predicted: bettingPrediction
      }

      predictions << prediction
    end

  PredictionJob.perform_later(predictions)
  end
end
