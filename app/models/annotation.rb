class Annotation < ActiveRecord::Base
	belongs_to :candy
	belongs_to :locations
	validates_presence_of :candy_id, :candy_sku, :device_id, :location_id
	validates_length_of :candy_sku, :maximum=>13
	#validates_uniqueness_of :candy_sku, :candy_id, :location_id
        validates_associated :candy, :locations
end
