class OddCreatorJob < ApplicationJob
  queue_as :default

  def perform(odds)

    odds.each do |odd|

      existing_odd = Odd.where(match_id: odd[:match_id]).where(provider: odd[:provider]).first

      if existing_odd.nil? && !odd[:match_id].nil?
          puts "========================"
          puts "PREPARING TO CREATE NEW ODD !!!!"
          puts "========================"

          newodd = Odd.new(
            home_odd: odd[:home_odd],
            draw_odd: odd[:draw_odd],
            away_odd: odd[:away_odd],
            provider: odd[:provider],
            match_id: odd[:match_id]
          )

          newodd.save
      end
    end
  end
end
