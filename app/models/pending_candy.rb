class PendingCandy < ActiveRecord::Base
  validates_uniqueness_of :sku
  validates_length_of :sku, :maximum=>13
  validates_presence_of :title, :subtitle, :sku
end
