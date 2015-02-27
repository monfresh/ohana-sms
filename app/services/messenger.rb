class Messenger
  def initialize(session)
    @session = session
  end

  def search_results
    locations_list_prefix + locations_list
  end

  def locations_list_prefix
    'Here are 5 locations that match your search. ' \
    'To get more details about a location, enter its number. '
  end

  def locations_list
    locations.map.with_index do |location, i|
      "##{i + 1}: #{location.name}"
    end.join(', ')
  end

  def categories
    "Please choose a category by entering its number: #{categories_list}"
  end

  def categories_list
    cat_array.map.with_index { |cat, i| "##{i + 1}: #{cat}" }.join(', ')
  end

  def cat_array
    Rails.application.secrets.categories
  end

  def locations
    Ohanakapa.search(
      'search',
      location: @session[:zip],
      kind: 'Human Services',
      category: cat_array[@session[:cats].to_i - 1],
      page: 1,
      per_page: 5
    )
  end

  def location
    locations[@session[:location].to_i - 1]
  end

  def location_details
    "#{name_and_short_desc} | #{phone} | #{address}"
  end

  def name_and_short_desc
    "#{location.name}: #{location.short_desc}"
  end

  def phone
    "Phone: #{location.phones.first.number}"
  end

  def address
    "Address: #{street_address}"
  end

  def street_address
    return "#{street_1}, #{city}, CA #{zip}" if street_2.blank?
    "#{street_1}, #{street_2}, #{city}, CA #{zip}"
  end

  def street_1
    location.address.street_1
  end

  def street_2
    location.address.street_2
  end

  def city
    location.address.city
  end

  def zip
    location.address.postal_code
  end
end
