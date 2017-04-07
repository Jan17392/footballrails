require 'sidekiq-scheduler'

class IqbetPredictionsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    predictions = []
    urls = []

      doc = Nokogiri::HTML(open("http://iq-bet.com/statistics/#{Date.today.strftime("%Y-%m-%d")}/", "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

      doc.css("tr").each do |content|
        if content.children.first.next_element
          url = content.children.first.next_element.children.text

          if url == "Name" || url == "Parent Directory"
            "dont want that in the array"
          else
            urls << url
          end
        end
      end

      p urls

      urls.each do |url|

      begin

          doc = Nokogiri::HTML(open("http://iq-bet.com/statistics/#{Date.today.strftime("%Y-%m-%d")}/#{url}", "User-Agent" => "Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20100101 Firefox/12.0 FirePHP/0.7.1"), nil, 'utf-8')

          if doc.css('#ststs_cell2').first
            homeTeam = doc.css('.title_main2').first.text
            awayTeam = doc.css('.title_main2').last.text
            homeProbability = doc.css('#ststs_cell2').first.text.split('1: ').last
            drawProbability = doc.css('#ststs_cell2').last.previous.text.split('X: ').last
            awayProbability = doc.css('#ststs_cell2').last.text.split('2: ').last
            bettingPrediction = doc.css('#ststs_cell2').first.previous.text


               prediction = {
                   home_team_id: homeTeam,
                   away_team_id: awayTeam,
                   home_probability: homeProbability.to_i,
                   draw_probability: drawProbability.to_i,
                   away_probability: awayProbability.to_i,
                   expert_id: 'iqbet',
                   date: Date.today.strftime("%d.%m.%Y"),
                   winner_predicted: bettingPrediction
               }

              predictions << prediction

              p prediction
          end

      rescue OpenURI::HTTPError => ex
        puts "-------------------------- Page not found -------------------------"
      end

      end
  p "--------------- STARTING JOB ----------------"
  PredictionJob.perform_later(predictions)
  end
end
