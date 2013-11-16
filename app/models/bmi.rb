require "date_timeliness_validator"

class Bmi < ActiveRecord::Base
  belongs_to :patient
  validates :patient,
    presence: true
  validates :bmi,
    presence:     true,
    numericality: {
      greater_than_or_equal_to: 0,
      message:                  "must be a non-negative number"
    }
  validates :date,
    presence:        true,
    date_timeliness: true
end