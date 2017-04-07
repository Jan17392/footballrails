class TeamsController < ApplicationController
  def index
    @teams = Team.all
    render json: @teams
  end

  def show
    if Team.exists?(params[:id])
      @team = Team.find(params[:id])
      render json: @team
    else
      render(:file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 403, :layout => false)
    end
  end

  def update
  end

  def delete
  end

  def create
  end
end
