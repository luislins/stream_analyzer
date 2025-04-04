class ViewerSnapshot < ApplicationRecord
  belongs_to :streamable, polymorphic: true
  
  validates :viewer_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :captured_at, presence: true
  
  scope :for_date_range, ->(start_date, end_date) { where(captured_at: start_date..end_date) }
end