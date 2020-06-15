# frozen_string_literal: true

class DrinksController < ApplicationController
  before_action :authenticate_user!

  def index
    return nil if redirect_to_user(false)

    author = User.find_by_id(params[:author_id])
    return nil if redirect_to_user(author)

    which_drinks_show(params[:drink] == 'true', author)
  end

  def new
    @drink = Drink.new
    @groups = current_user.groups
  end

  def create
    @drink = current_user.drinks.build(drink_params)
    group = Group.find_by_id(params[:group_id])
    @drink.group_id = group.id unless group.nil?

    if @drink.save
      redirect_to current_user
    else
      flash.now[:error] = @drink.errors.full_messages
      @groups = current_user.groups
      render :new
    end
  end

  private

  def drink_params
    params.require(:drink).permit(:name, :amount, :group_id)
  end

  def which_drinks_show(drink, author)
    if drink
      @drinks = Drink.by_user(author.id)
      @drinks_title = 'All my drinks'
      @total_drinks = author.sum_drinks
    else
      @drinks = Drink.by_user(author.id, false)
      @drinks_title = 'All my external drinks'
      @total_drinks = author.sum_drinks(false)
    end
  end

  def redirect_to_user(author = nil)
    return unless author.nil? || params[:author_id].nil?

    redirect_to user_path(current_user)
    true
  end
end
