class User < ApplicationRecord
  validates :name, :city, :country, :contact_number, presence: true
  validates :email, presence: true, uniqueness: true 

  before_save :check_state_present
  validate :validate_country

  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
  end

  def check_state_present
    self.state = self.country if state.nil?
  end

  def validate_country
    return if country.nil?

    unless User.country_code_list.include?(country)
      errors.add(:country, 'is not valid')
    end 
  end

  def self.country_code_list
    ISO3166::Country.all.map { |country| country.alpha2 }
  end

end
