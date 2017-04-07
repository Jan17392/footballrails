class OddsController < ApplicationController
  def show
  end

  def index
    @odds = Odd.all
    BetexplorerMatchesScraperJob.perform_now
  end

  def update
  end

  def create
    data = params[:odds]
    odds = data.to_a


    OddCreatorJob.perform_later(odds: odds)

    render json: {}, status: :ok
  end

  def new
  end

  def destroy
  end
end
