require "id_validator"
require "date_timeliness_validator"

class Acr < ActiveRecord::Base
  belongs_to :patient

  include I18n::Alchemy
  localize :date, using: :date

  validates :patient_id,
    id:       true,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      only_integer: true
    }
  validates :date,
    presence:        true,
    date_timeliness: true
  validates :acr,
    presence:     true,
    numericality: {
      only_integer:             true,
      greater_than_or_equal_to: 0,
      message:                  "must be a non-negative number with no decimal places"
    }
end
