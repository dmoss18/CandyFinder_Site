module Places

  def self.key
    return 'AIzaSyB7Px85Mowk_a-S05aVqfvnzsDX98qLjYA'
  end

  def self.details_url
    return 'https://maps.googleapis.com/maps/api/place/details/json?'
  end

  def self.search_url
    return 'https://maps.googleapis.com/maps/api/place/search/json?'
  end

  def self.get_search_url(lat, lon, radius=1600)
    #radius is optional
    return  self.search_url + "location=#{lat},#{lon}&radius=#{radius}&sensor=true&key=#{self.key}"
  end

  def self.search_url_with_filter(lat, lon, filter={ 'radius' => 1600 })
    #filter keys can be: keyword, language, name, rankby (only two values for this are prominence and distance)
    	#If rankby is included, radius must NOT be included
    if filter['rankby']
      return self.search_url + "location=#{lat},#{lon}&types=#{filter['types']}&sensor=true&key=#{self.key}&name=#{filter['name']}&keyword=#{filter['keyword']}&language=#{filter['language']}&rankby=#{filter['rankby']}"
    else
      return self.search_url + "location=#{lat},#{lon}&types=#{filter['types']}&radius=#{filter['radius']}&sensor=true&key=#{self.key}&name=#{filter['name']}&keyword=#{filter['keyword']}&language=#{filter['language']}"
    end
  end

  def self.get_details_url(reference)
    return self.details_url + "key=#{self.key}&reference=#{reference}&sensor=true"
  end

  def self.types
    return 'gas_station|grocery_or_supermarket|liquor_store|shopping_mall|convenience_store'
  end

end
