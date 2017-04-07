# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'CSV'

#CREATING THE MAPPING MATRIX
CSV.foreach('csv_input/teammapping_clean_europe.csv') do |row|

  Team.create(name: row[1].downcase)

  id = Team.last().id

  TeamMapping.create(
    team_id: id,
    reference: row[0].nil? ? nil : row[0].downcase,
    longname: row[1].nil? ? nil : row[1].downcase,
    shortname: row[2].nil? ? nil : row[2].downcase,
    zulubet: row[3].nil? ? nil : row[3].downcase,
    statarea: row[4].nil? ? nil : row[4].downcase,
    hintwise: row[5].nil? ? nil : row[5].downcase,
    iqbet: row[6].nil? ? nil : row[6].downcase,
    bettingclosed: row[7].nil? ? nil : row[7].downcase,
    proprediction: row[8].nil? ? nil : row[8].downcase,
    prosoccereu: row[9].nil? ? nil : row[9].downcase,
    prosoccergr: row[10].nil? ? nil : row[10].downcase,
    betexplorer: row[11].nil? ? nil : row[11].downcase,
    )
end

p "TeamMapping seeded"

#CREATING THE COUNTRIES
CSV.foreach('csv_input/countries.csv') do |row|
  Country.create(
    countryname: row[1].downcase
    )
end

p "Countries seeded"

#CREATING THE LEAGUES
League.create(leaguename: "Belgium Jupiler League".downcase, country_id: 1, league_reference: 1)
League.create(leaguename: "England Premier League".downcase, country_id: 2, league_reference: 1729)
League.create(leaguename: "France Ligue 1".downcase, country_id: 3, league_reference: 4769)
League.create(leaguename: "Germany 1. Bundesliga".downcase, country_id: 4, league_reference: 7809)
League.create(leaguename: "Italy Serie A".downcase, country_id: 5, league_reference: 10257)
League.create(leaguename: "Netherlands Eredivisie".downcase, country_id: 6, league_reference: 13274)
League.create(leaguename: "Poland Ekstraklasa".downcase, country_id: 7, league_reference: 15722)
League.create(leaguename: "Portugal Liga ZON Sagres".downcase, country_id: 8, league_reference: 17642)
League.create(leaguename: "Scotland Premier League".downcase, country_id: 9, league_reference: 19694)
League.create(leaguename: "Spain LIGA BBVA".downcase, country_id: 10, league_reference: 21518)
League.create(leaguename: "Switzerland Super League".downcase, country_id: 11, league_reference: 24558)

p "Leagues seeded"

#CREATING THE MATCHES
CSV.foreach('csv_input/matches.csv') do |row|

  homeTeam = TeamMapping.where(reference: row[7]).map(&:team_id)
  awayTeam = TeamMapping.where(reference: row[8]).map(&:team_id)
  league = League.where(league_reference: row[2]).map(&:id)

  Match.create(
    league_id: league.nil? ? nil : league[0],
    old_reference: row[0],
    season: row[3].downcase,
    round: row[4],
    date: row[5],
    home_team_id: homeTeam.nil? ? nil : homeTeam[0],
    away_team_id: awayTeam.nil? ? nil : awayTeam[0],
    home_goals: row[9],
    away_goals: row[10],
    home_goals_halftime: nil,
    away_goals_halftime: nil,
    status: "finished"
  )
end

p "Matches seeded"

#CREATING EXPERTS
Expert.create(name: "zulubet")
Expert.create(name: "bettingclosed")
Expert.create(name: "iqbet")
Expert.create(name: "hintwise")
Expert.create(name: "proprediction")
Expert.create(name: "prosoccereu")
Expert.create(name: "prosoccergr")
Expert.create(name: "statarea")
Expert.create(name: "windrawwin")

p "Experts seeded"



p "Finished Seeding"
