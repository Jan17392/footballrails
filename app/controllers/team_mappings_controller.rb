require 'csv'
require 'fuzzy_match'

class TeamMappingsController < ApplicationController
  def index
  end

  def show
    @provider = params[:provider].downcase
    @team = params[:team].downcase

    @result = TeamMapping.where(@provider => @team).first

    if @result
      @result = @result.id
    else
      @result = 0
    end

    render json: @result
  end

  def new
  end

  def create
  end

  def update
  end
end
