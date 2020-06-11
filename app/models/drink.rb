class Drink < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  scope :by_user, lambda { |author_id, grouped_ones = true|
    if !author_id.nil?
      if grouped_ones
        Drink.where(author_id: author_id).where.not(group_id: nil).order(created_at: :desc).includes(:group)
      else
        Drink.where(author_id: author_id).where(group_id: nil).order(created_at: :desc)
      end
    end
  }
end
