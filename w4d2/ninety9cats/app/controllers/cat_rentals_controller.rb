class CatRentalsController < ApplicationController

  def new
    @cat_rental = CatRentalRequest.new
  end

  def create
    @cat_rental = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental.save
      redirect_to("/cat_rentals")
    else
      flash[:error] = @cat_rental.errors.full_messages
      render :new
    end
  end

  def show
    @cat_rental = CatRentalRequest.find(params[:id])
  end

  def index
    @cat_rentals = CatRentalRequest.all
  end

  def approve
    @cat_rental = CatRentalRequest.find(params[:id])
    @cat_rental.approve!
    redirect_to cat_url(Cat.find(@cat_rental.cat_id))
  end

  def deny
    @cat_rental = CatRentalRequest.find(params[:id])
    @cat_rental.deny!
    redirect_to cat_url(Cat.find(@cat_rental.cat_id))
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental).permit(:cat_id, :start_date, :end_date)
  end

end
