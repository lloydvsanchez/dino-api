class Cage < ApplicationRecord
  has_many :dinosaurs, dependent: :destroy

  enum :power, {active: true, down: false}

  validate :cannot_power_down, if: :will_save_change_to_power?

  accepts_nested_attributes_for :dinosaurs

  def current_size
    dinosaurs.count
  end

  def full?
    current_size >= capacity
  end

  def active?
    power == 'active'
  end

  def has_carnivores?
    dinosaurs.carnivore.exists?
  end

  def first_carnivore
    return nil unless has_carnivores?

    dinosaurs.carnivore.first
  end

  def first_error_message
    errors&.first&.full_message
  end

  private

  def cannot_power_down
    errors.add(:cage, "cannot power down if still has dinosaur/s") if power == 'down' &&  dinosaurs.count > 0
  end
end
