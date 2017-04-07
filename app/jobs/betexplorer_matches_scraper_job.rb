require 'sidekiq-scheduler'
require 'Nokogiri'
require 'open-uri'

class BetexplorerMatchesScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)
    doc = Nokogiri::HTML(open("http://www.betexplorer.com/next/soccer/"), nil, 'utf-8')

    matches = []

    doc.css(".table-matches__tt").each do |content|

      # Team Names
      teamNames = content.children.children.last.text.split(' - ')
      match_time = content.children.children.first.text
      homeTeam = teamNames.first
      awayTeam = teamNames.last

      # Full Time Score
      score = content.next_element.next_element.children.text
      home_goals = score.split(':').first.strip
      away_goals = score.split(':').last.strip
      if home_goals.length > 2 || away_goals.length > 2
        home_goals = ""
        away_goals = ""
      end
      if home_goals.length == 1 || home_goals.length == 2
        status = "finished"
      else
        status = "open"
      end

      # Half Time Score
      halftimegoals = content.next_element.next_element.next_element.text
      goalssplit = halftimegoals.split(", ")
      home_goals_first_half = "";
      away_goals_first_half = "";
      home_goals_second_half = "";
      away_goals_second_half = "";

      # Check whether first and second half result is in the array
      if goalssplit.count != 2
        p "no halftime results"
      else
        scorefirsthalf = goalssplit.first.slice(1..-1)
        home_goals_first_half = scorefirsthalf.split(':').first
        away_goals_first_half = scorefirsthalf.split(':').last
        scoresecondhalf = goalssplit.last.slice(0..2)
        home_goals_second_half = scoresecondhalf.split(':').first
        away_goals_second_half = scoresecondhalf.split(':').last
      end

      # URL and Referencer
      url = "http://www.betexplorer.com#{content.children.last.attribute('href').value}"
      matchId = url.slice(-9, 8)

      # If no match Id is given the url is worthless too
      if !matchId
        url = ""
        matchId = ""
      end

      # Date
      match_date = Date.today.strftime("%d.%m.%Y")

      match = {
        expert: 'betexplorer',
        home_team_id: homeTeam,
        away_team_id: awayTeam,
        date: match_date,
        home_goals: home_goals,
        away_goals: away_goals,
        status: status,
        home_goals_first_half: home_goals_first_half,
        away_goals_first_half: away_goals_first_half,
        home_goals_second_half: home_goals_second_half,
        away_goals_second_half: away_goals_second_half,
        match_url: url,
        match_referencer: matchId
      }

      matches << match
    end

    MatchCreatorJob.perform_later(matches)
  end
end
