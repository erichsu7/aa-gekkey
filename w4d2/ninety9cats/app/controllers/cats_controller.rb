class CatsController < ApplicationController

  def index
    @cats = Cat.all
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to(cat_url(@cat))
    else
      render :new
    end
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end
end
