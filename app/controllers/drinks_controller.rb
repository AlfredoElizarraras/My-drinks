class DrinksController < ApplicationController
  def index
    author = User.find(params[:author_id])
    return if author.nil?

    @drinks = Drink.by_user(author.id)
    @drinks_title = 'All my external drinks'
    @total_drinks = author.sum_drinks
  end
end
