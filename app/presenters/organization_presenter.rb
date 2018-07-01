# frozen_string_literal: true

class OrganizationPresenter
  def initialize(location)
    @location = location
  end

  def name
    org_name = location.organization.name
    " (#{org_name})" if location.name != org_name
  end

  private

  attr_reader :location
end
