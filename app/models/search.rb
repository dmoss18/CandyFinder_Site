class Search < ActiveRecord::Base
	#validates_uniqueness_of :candy_id
	validates_presence_of :candy_id, :search_term, :device_id
	belongs_to :candy	
end

