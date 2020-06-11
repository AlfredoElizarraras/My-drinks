# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :drinks, dependent: :destroy, foreign_key: :author_id

  def sum_drinks(grouped = true)
    if grouped
      drinks.where.not(group_id: nil).sum(:amount).to_f
    else
      drinks.where(group_id: nil).sum(:amount).to_f
    end
  end
end
