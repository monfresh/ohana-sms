# frozen_string_literal: true

module CategoriesPresenter
  def self.call
    I18n.t('choose_category', list: numbered_categories)
  end

  def self.numbered_categories
    I18n.t('categories').map.with_index { |cat, index| "##{index + 1}: #{cat}" }.join(', ')
  end
end
