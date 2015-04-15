class Messenger
  def initialize(session)
    @session = session
  end

  def search_results
    locations_list_prefix + locations_list
  end

  def locations_list_prefix
    I18n.t('results_intro')
  end

  def locations_list
    locations.map.with_index do |location, i|
      "##{i + 1}: #{location.name}#{org_name_for(location)}"
    end.join(', ')
  end

  def categories
    I18n.t('choose_category', list: categories_list)
  end

  def categories_list
    localized_cats.map.with_index { |cat, i| "##{i + 1}: #{cat}" }.join(', ')
  end

  def localized_cats
    I18n.t('categories')
  end

  def cat_array
    Rails.application.secrets.categories
  end

  def locations
    @locations ||= Ohanakapa.search(
      'search',
      location: @session[:zip],
      keyword: search_term,
      kind: 'Human Services',
      page: 1,
      per_page: 5)
  end

  def search_term
    cat_array[@session[:cats].to_i - 1]
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

  def org_name_for(location)
    return if location.name == location.organization.name
    " (#{location.organization.name})"
  end

  def phone
    "#{I18n.t('phone')}: #{location.phones.first.number}"
  end

  def address
    "#{I18n.t('address')}: #{street_address}"
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
