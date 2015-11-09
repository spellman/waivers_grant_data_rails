class Record
  include ActiveModel::Model
  CouldNotSaveAllModels = Class.new(StandardError)

  def self.model_names
    [
      "a1c",
      "acr",
      "blood_pressure",
      "bun_and_creatinine",
      "cholesterol",
      "ckd_stage",
      "eye_exam",
      "foot_exam",
      "measurements",
      "testosterone"
    ]
  end

  attr_accessor :patient_id, :models, *self.model_names.map(&:to_sym)

  def initialize attrs = default_attributes
    attrs = Hash[attrs.map { |k, v| [k.to_s, v] }]
    @patient_id = attrs.delete "patient_id"
    @models = []
    initialize_models attrs
  end

  validate :some_model_not_blank
  validate :aggregate_model_errors

  def save
    if valid?
      try_save_models
    end
  end

  # private
  def default_attributes
    Hash[self.class.model_names.map { |model_name| [model_name, {}] }]
  end

  def initialize_models params
    params.each do |model_name, model_attrs|
      initialize_model name: model_name,
                       attributes: model_attrs.merge({"patient_id" => patient_id})
    end
  end

  def initialize_model name: nil, attributes: nil
    model_class = name.titlecase.gsub("\s", "").constantize
    model = model_class.new
    model.localized.assign_attributes attributes
    models << model
    send "#{name}=", model
  end

  def try_save_models
    begin
      save_models!
      true
    rescue CouldNotSaveAllModels
      aggregate_model_errors
      false
    end
  end

  def save_models!
    ActiveRecord::Base.transaction do
      save_results = []
      non_blank_models.each { |model| save_results << model.save }
      raise CouldNotSaveAllModels unless save_results.all?
    end
  end

  def some_model_not_blank
    errors.add :base, "Nothing to save! Please enter some patient data." if non_blank_models.empty?
  end

  def aggregate_model_errors
    non_blank_models.reverse.each do |model|
      unless model.valid?
        model.errors.each do |key, values|
          errors[key] = values
        end
      end
    end
  end

  def non_blank_models
    models.reject { |model| blank_model? model }
  end

  def blank_model? model
    model.attributes.reject { |k, v| k == "patient_id" }.all? { |k, v| v.blank? }
  end
end
