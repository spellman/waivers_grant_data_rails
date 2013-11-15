require "date_timeliness_validator"

class EyeExam < ActiveRecord::Base
  belongs_to :patient
  validates :patient,
    presence: true
  validates :date,
    presence:        true,
    date_timeliness: true
end
