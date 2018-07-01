# frozen_string_literal: true

class StreetAddressPresenter
  def initialize(address)
    @address = address
  end

  delegate :city, :state_province, :zip, to: :address

  def call
    return "#{first_line}, #{city}, #{state_province} #{zip}" if second_line.blank?

    "#{first_line}, #{second_line}, #{city}, #{state_province} #{zip}"
  end

  private

  attr_reader :address

  def first_line
    address.address_1
  end

  def second_line
    address.address_2
  end
end
