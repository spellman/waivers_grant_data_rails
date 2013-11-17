require "id_validator"
require "date_timeliness_validator"

class EyeExam < ActiveRecord::Base
  belongs_to :patient
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
end
