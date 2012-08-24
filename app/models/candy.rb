class Candy < ActiveRecord::Base
	has_many :search
	has_many :annotations
	validates_uniqueness_of :sku
	validates_length_of :sku, :maximum => 13
	validates_presence_of :title, :sku, :description, :alias

  def self.search_by_name(name)
    return Candy.find(:all, :conditions => ["title like ?", "%#{name}%"], :order => "title ASC, subtitle ASC")
  end

  def self.ids_by_name(name)
    return Candy.find(:all, :select => "id", :conditions => ["title like ?", "%#{name}%"], :order => "title ASC, subtitle ASC").map { |x| x.id }
  end

  def self.candies_from_location_ids(ids)
    annots = Annotation.find_all_by_location_id(ids)
    unless annots.class == [].class
      @candy = [annots]
    end
    ahash = {}
    annots.each do |a|
      ahash[a.candy_id] = a.updated_at
    end
    candies = Candy.find( annots.map { |x| x.candy_id } )
    unless candies.class == [].class
      candies = [candies]
    end
    candies.sort! { |a,b| a.title.downcase <=> b.title.downcase }
    i = 0
    while(i < candies.length)
      candies[i].updated_at = ahash[candies[i].id]
      i += 1
    end
    return candies
  end

  def self.candy_from_pending(p)
    c = self.new
    c.title = p.title
    c.subtitle = p.subtitle
    c.sku = p.sku
    return c
  end

end
