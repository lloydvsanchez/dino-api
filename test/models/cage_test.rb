require "test_helper"

class CageTest < ActiveSupport::TestCase
  test "Cages have a maximum capacity for how many dinosaurs it can hold." do
    little_foot = dinosaurs(:little_foot)
    cage = little_foot.cage

    assert_equal cage.dinosaurs.count, cage.capacity
    assert cage.full?
  end

  test "Cages know how many dinosaurs are contained" do
    little_foot = dinosaurs(:little_foot)
    assert little_foot.cage.current_size
  end

  test "Cages have a power status of ACTIVE or DOWN" do
    little_foot = dinosaurs(:little_foot)
    h_cage = cages(:h_cage)

    assert_equal little_foot.cage.power, "active"
    assert_raises ArgumentError do
      h_cage.update(power: 'active1')
    end
  end

  test "Cages cannot be powered off if they contain dinosaurs." do
    little_foot = dinosaurs(:little_foot)
    cage = little_foot.cage
    cage.update(power: 'down')
    assert_equal cage.errors.messages, {:cage=>["cannot power down if still has dinosaur/s"]}
  end
end
