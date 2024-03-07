require "test_helper"

class CagesControllerTest < ActionDispatch::IntegrationTest
  test "GET" do
    get api_v1_cages_url
    assert_response :success

    res = Cage.all.collect do |c|
      c.as_json(
        only: %w[id name power capacity],
        include: {
          dinosaurs: {
            only: %w[id name species dino_type]
          }
        }
      )
    end
    assert_equal JSON.parse(response.body), res
  end

  test "GET with query" do
    get api_v1_cages_url, params: { "dinosaurs" => { "species" => "Velociraptor" } }
    assert_response :success

    blue = dinosaurs(:blue)
    cage = blue.cage.as_json(only: %w[id name power capacity])
    blue_json = blue.as_json(only: %w[id name species dino_type])

    assert_equal JSON.parse(response.body), [cage.merge({ "dinosaurs" => [blue_json] })]
  end

  test "POST" do
    params = {
      "name"=>"H Cage",
      "power"=>"active",
      "capacity"=>8,
      "dinosaurs"=> [
        {"name"=>"Little foot", "species"=>"Brachiosaurus", "dino_type"=>"herbivore"},
        {"name"=>"Sarah", "species"=>"Triceratops", "dino_type"=>"herbivore"}]
    }
    post api_v1_cages_url, params: params

    assert_response :success
    assert_equal params, Cage.last.as_json(
      only: %w[name power capacity],
      include: {
        dinosaurs: {
          only: %w[name species dino_type]
        }
      }
    )
  end

  test "UPDATE" do
    params = {
      "name"=>"H Cage",
      "power"=>"active",
      "capacity"=>8
    }
    patch api_v1_cage_path(Cage.last), params: params
    
    assert_response :success
    assert_equal params, Cage.last.as_json(
      only: %w[name power capacity]
    )
  end

  test "DELETE" do
    assert_difference("Cage.count", -1) do
      delete api_v1_cage_url(Cage.first)
    end
  end
end

