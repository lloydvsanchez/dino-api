class Dinosaur < ApplicationRecord
  belongs_to :cage

  HERBIVORE_SPECIE=%w[Brachiosaurus Stegosaurus Ankylosaurus Triceratops]
  CARNIVORE_SPECIE=%w[Tyrannosaurus Velociraptor Spinosaurus Megalosaurus]

  enum :dino_type, [:herbivore, :carnivore]
  enum :species, (CARNIVORE_SPECIE + HERBIVORE_SPECIE)

  validates :name, presence: true

  before_validation :set_dino_type, if: :will_save_change_to_species?

  validate :cage_related_validations#, if: :will_save_change_to_cage_id?

  private

  def set_dino_type
    self.dino_type = self.class.dino_types[(CARNIVORE_SPECIE.include?(species) ? "carnivore" : "herbivore")]
  end

  def cage_related_validations
    ['cage_power_active',
     'cage_for_carnivores_only',
     'cage_for_carnivores_of_same_species_only'].each do |str|
       send(str.to_sym)
       return if errors.count > 0
    end
  end

  def cage_for_carnivores_only
    if cage.has_carnivores? && dino_type == 'herbivore'
      errors.add(:cage, "cannot add herbivores in a cage of carnivores")
    end
  end

  def cage_for_carnivores_of_same_species_only
    return unless cage.has_carnivores?

    if cage.dinosaurs.carnivore.pluck(:species) != [species]
      errors.add(:cage, "cannot mix carnivores of different species")
    end
  end

  def cage_power_active
    return true unless cage

    errors.add(:cage, "must be power active") unless cage.active?
  end
end
