# frozen_string_literal: true

require_relative '../presenters/street_address_presenter'
require_relative '../presenters/organization_presenter'

class Messenger
  AVAILABLE_CATEGORIES = Rails.application.secrets.categories.freeze

  def initialize(session)
    @session = session
  end

  def search_results
    I18n.t('results_intro') + locations_list
  end

  def locations
    @locations ||= Ohanakapa.search(
      'search',
      location: @session[:zip],
      keyword: search_term,
      kind: 'Human Services',
      page: 1,
      per_page: 5
    )
  end

  def location_details
    "#{name_and_short_desc} | #{phone} | #{address}"
  end

  private

  def locations_list
    locations.map.with_index do |location, index|
      "##{index + 1}: #{location.name}#{OrganizationPresenter.new(location).name}"
    end.join(', ')
  end

  def search_term
    selected_category = @session[:cats]
    if selected_category.match?(/\A([1-9]|1[0-1])\z/)
      return AVAILABLE_CATEGORIES[selected_category.to_i - 1]
    end
    selected_category
  end

  def location
    locations[@session[:location].to_i - 1]
  end

  def name_and_short_desc
    "#{location.name}: #{location.short_desc}"
  end

  def phone
    "#{I18n.t('phone')}: #{location.phones.first.number}"
  end

  def address
    "#{I18n.t('address')}: #{StreetAddressPresenter.new(location.address).call}"
  end
end
