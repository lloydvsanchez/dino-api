require "test_helper"

class DinosaurTest < ActiveSupport::TestCase
  test "Each dinosaur must have a name" do
    dinosaur = dinosaurs(:little_foot)
    assert_equal dinosaur.name, 'little foot'
  end

  test "Each dinosaur is considered an herbivore or a carnivore, depending on its species" do
    little_foot = dinosaurs(:little_foot)
    big_mouth = dinosaurs(:big_mouth)

    assert_equal little_foot.dino_type, 'herbivore'
    assert_equal big_mouth.dino_type, 'carnivore'
  end

  test "Each dinosaur must have a species" do
    little_foot = dinosaurs(:little_foot)
    assert little_foot.species
  end

  test "Dinosaurs cannot be moved into a cage that is powered down." do
    little_foot = dinosaurs(:little_foot)
    h_cage = cages(:h_cage)
    h_cage.update(power: "down")
    little_foot.update(cage: h_cage)

    assert_equal little_foot.errors.messages, {:cage=>["must be power active"]}
  end

  test "Carnivores can only be in a cage with other dinosaurs of the same species." do
    blue = dinosaurs(:blue)
    big_mouth = dinosaurs(:big_mouth)

    blue.update(cage: big_mouth.cage)
    assert_equal blue.errors.messages, {:cage=>["cannot mix carnivores of different species"]}
  end

  test "Herbivores cannot be in the same cage as carnivores." do
    little_foot = dinosaurs(:little_foot)
    big_mouth = dinosaurs(:big_mouth)

    little_foot.update(cage: big_mouth.cage)
    assert_equal little_foot.errors.messages, {:cage=>["cannot add herbivores in a cage of carnivores"]}
  end
end
