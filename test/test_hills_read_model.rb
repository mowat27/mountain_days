require 'minitest/autorun'
require 'hills/read_model'

class HillsReadModelTest < Minitest::Test
  def setup
    @read_model = Hills::ReadModel.new
  end

  def test_new_munro_added_creates_munro
    @read_model.load_event(:new_munro_added, id: "1", name: "Ben Vane")
    @read_model.load_event(:new_munro_added, id: "3", name: "Sgurr Fiona")
    @read_model.load_event(:new_munro_added, id: "2", name: "Ben Chronzie")

    assert_equal(3, @read_model.hills.count)
    assert_equal("1", @read_model.hills[0]["id"])
    assert_equal("Ben Vane", @read_model.hills[0]["name"])
    assert_equal("3", @read_model.hills[1]["id"])
    assert_equal("Sgurr Fiona", @read_model.hills[1]["name"])
    assert_equal("2", @read_model.hills[2]["id"])
    assert_equal("Ben Chronzie", @read_model.hills[2]["name"])
  end

  def test_adding_a_summit_latitude_and_longitude
    @read_model.load_event(:new_munro_added, id: "1", name: "Ben Vane")
    @read_model.load_event(:new_munro_added, id: "3", name: "Sgurr Fiona")
    @read_model.load_event(:summit_latitude_added, id: "1", value: 1.23)
    @read_model.load_event(:summit_longitude_added, id: "1", value: 4.56)

    assert_equal(1.23, @read_model["1"]["summit_latitude"])
    assert_equal(4.56, @read_model["1"]["summit_longitude"])
    assert_nil(@read_model["3"]["summit_latitude"])
    assert_nil(@read_model["3"]["summit_longitude"])
  end

  def test_adding_a_starting_point
    @read_model.load_event(:new_munro_added, id: "1", name: "Ben Vane")
    @read_model.load_event(:new_munro_added, id: "3", name: "Sgurr Fiona")
    @read_model.load_event(:starting_point_added, id: "3", name: "car park", latitude: 4.567, longitude: -1.432)

    assert_equal 0, @read_model["1"].starting_points.count
    assert_equal 1, @read_model["3"].starting_points.count
    assert_equal "car park", @read_model["3"].starting_points.first["name"]
    assert_equal 4.567, @read_model["3"].starting_points.first["latitude"]
    assert_equal -1.432, @read_model["3"].starting_points.first["longitude"]
  end
end
