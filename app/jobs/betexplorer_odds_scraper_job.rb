require 'sidekiq-scheduler'
require 'Nokogiri'
require 'open-uri'

class BetexplorerOddsScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)

    matches = matches_without_odds

    #p matches
    odds = []

    matches.each do |match|

      #p match


      if match.match_referencer
        #p "http://www.betexplorer.com/gres/ajax/matchodds.php?p=1&b=1x2&e=#{match.match_referencer}"

        doc = Nokogiri::HTML(
          open(
            "http://www.betexplorer.com/gres/ajax/matchodds.php?p=1&b=1x2&e=#{match.match_referencer}",
            "User-Agent" => "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Mobile Safari/537.36",
            "Host" => "www.betexplorer.com",
            "Accept-Language" => "de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4",
            "Upgrade-Insecure-Requests" => "1",
            "Accept" => "application/json, text/javascript, */*; q=0.01",
            "Cache-Control" => "max-age=0",
            "Connection" => "keep-alive",
            "Referer" => match.match_url,
            "X-Requested-With" => "XMLHttpRequest",
            "Content-Type" => "text/html;charset=utf-8"
          ),
          nil,
          'utf-8'
        )

        doc.search('table').search("td").each do |td|

          if td.attributes["table-main__odds--first"]
            provider = td.previous_element.previous_element.children.last.children.attr('title').value.gsub(/\\/,'').gsub('"','')
            home_odd = td.attributes["data-odd"].value[/[\d.,]+/].gsub(',','.').to_f
            draw_odd = td.next_element.attributes["data-odd"].value[/[\d.,]+/].gsub(',','.').to_f
            away_odd = td.next_element.next_element.attributes["data-odd"].value[/[\d.,]+/].gsub(',','.').to_f

            odd = {
              match_id: match.id,
              provider: provider,
              home_odd: home_odd,
              draw_odd: draw_odd,
              away_odd: away_odd
            }

            odds << odd
          end

        end

      end
    end
    p odds
    OddCreatorJob.perform_later(odds)
  end




  def matches_without_odds
    matches = Match.includes(:odds).where(odds: { match_id: nil }).where.not(match_referencer: nil).sample(50)
    return matches
  end
end

