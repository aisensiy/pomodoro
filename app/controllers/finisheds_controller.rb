class FinishedsController < ApplicationController
  respond_to :json

  def index
    @finisheds = Finished.order('updated_at desc')
    respond_with @finisheds
  end

  def create
    @finished = Finished.new params[:finished]
    @finished.save
    respond_with @finished
  end

  def update
    @finished = Finished.find_by_id(params[:id])
    @finished.update_attributes(params[:finished]) if @finished
    respond_with @finished, status: if @finished.nil? then :not_found else 200 end
  end
end
