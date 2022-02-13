class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]


  def index
    @prototype = Prototype.includes(:user)
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.save 
       redirect_to prototype_path
    else
      @prototype.update(prototype_params)
      render :edit
    end
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save 
      redirect_to root_path
    else
      @prototype = Prototype.new(prototype_params)
      render new_prototype_path
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
  params.require(:prototype).permit(:image,:title,:concept,:catch_copy).merge(user_id: current_user.id)
  end

end
