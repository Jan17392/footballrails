class MatchCreatorJob < ApplicationJob
  queue_as :default

  def perform(matches)
    matches.each do |match|

      # Create a range of matchdates to equal out time zone differences
      starts = match[:date].to_datetime - 1
      ends = starts + 2

      # Look-up the Team names provided in the Mapping Table. Match will only be created if both are found
      home_id = TeamMapping.where(match[:expert].downcase => match[:home_team_id].downcase).first
      away_id = TeamMapping.where(match[:expert].downcase => match[:away_team_id].downcase).first
      match[:match_id] = Match.where(home_team_id: home_id).where(away_team_id: away_id).where(date: starts..ends).first

      # Create Match if both teams are known but the match does not yet exist
      if !home_id.nil? && !away_id.nil? && match[:match_id].nil?
        match[:home_team_id] = Team.find(home_id[:team_id])[:id]
        match[:away_team_id] = Team.find(away_id[:team_id])[:id]

          puts "========================"
          puts "PREPARING TO CREATE NEW MATCH !!!!"
          puts "========================"

          newmatch = Match.new(
            home_team_id: match[:home_team_id],
            date: match[:date],
            away_team_id: match[:away_team_id],
            home_goals: match[:home_goals],
            away_goals: match[:away_goals],
            status: match[:status],
            home_goals_first_half: match[:home_goals_first_half],
            away_goals_first_half: match[:away_goals_first_half],
            home_goals_second_half: match[:home_goals_second_half],
            away_goals_second_half: match[:away_goals_second_half],
            match_url: match[:match_url],
            match_referencer: match[:match_referencer]
          )

          newmatch.save

      # Write unknown team to file to see why I dont have it in the team mapping
      elsif home_id.nil? != away_id.nil?
        CSV.open("csv_input/unknown_teams.csv", "ab") do |csv|
          csv << [home_id, away_id, match[:home_team_id], match[:away_team_id], match[:date]]
        end

      # Both Teams are known and the match already exists - update existing match with more params
      elsif !home_id.nil? && !away_id.nil? && !match[:match_id].nil?
        match[:home_team_id] = Team.find(home_id[:team_id])[:id]
        match[:away_team_id] = Team.find(away_id[:team_id])[:id]
        updatematch = Match.find(match[:match_id])

          puts "========================"
          puts "PREPARING TO UPDATE MATCH !!!!"
          puts "========================"

          updateparams = {
            home_team_id: match[:home_team_id],
            date: match[:date],
            away_team_id: match[:away_team_id],
            home_goals: match[:home_goals],
            away_goals: match[:away_goals],
            status: match[:status],
            home_goals_first_half: match[:home_goals_first_half],
            away_goals_first_half: match[:away_goals_first_half],
            home_goals_second_half: match[:home_goals_second_half],
            away_goals_second_half: match[:away_goals_second_half],
            match_url: match[:match_url],
            match_referencer: match[:match_referencer]
          }

          updatematch.update(updateparams)
      end
    end
  end
end
