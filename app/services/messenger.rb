class Messenger
  def initialize(body)
    @body = body
  end

  def search_results
    locations_list_prefix + locations_list
  end

  def locations_list_prefix
    'Here are 5 locations that match your search. ' \
    'To see more details about a location, enter its number.'
  end

  def locations_list
    locations.map.with_index do |location, i|
      "##{i + 1}: #{location.name}"
    end.join(', ')
  end

  def locations
    Ohanakapa.search(
      'search',
      location: @body,
      kind: 'Human Services',
      page: 1,
      per_page: 5
    )
  end

  def location_details
    locations[@body.to_i - 1].phones.first.number
  end
end
