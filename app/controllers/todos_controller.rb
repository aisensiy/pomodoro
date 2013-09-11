class TodosController < ApplicationController
  respond_to :json

  def index
    @todos = Todo.order('updated_at desc')
    respond_with @todos
  end

  def create
    @todo = Todo.new params[:todo]
    @todo.save
    respond_with @todo
  end

  def update
    @todo = Todo.find_by_id(params[:id])
    if @todo
      @todo.update_attributes(params[:todo])
      if @todo.done
        @finished = Finished.create content: "#done #{@todo.content}",
                                    started_at: @todo.created_at,
                                    end_at: Time.now
      else
        @finished = Finished.where(started_at: @todo.created_at, content: "#done #{@todo.content}").first
        @finished.destroy if @finished
      end
    end
    attrs = @todo.attributes
    attrs['related_finished'] = @finished.attributes if attrs
    render json: attrs, status: if @todo.nil? then :not_found else 200 end
  end

  def destroy
    @todo = Todo.find_by_id(params[:id])
    @todo.destroy if @todo
    respond_with @todo, status: if @todo.nil? then :not_found else 200 end
  end
end
