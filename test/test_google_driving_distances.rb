require "minitest/autorun"
require "google_driving_distances"

class TestGoogleDrivingDistances < Minitest::Test
  include MountainDays::RoadDistances

  def setup
    @raw_xml = File.read(File.dirname($0) + "/data/buckingham_st_to_slioch.xml")
  end

  def test_reponse_is_valid
    assert journey(@raw_xml).valid?
  end

  def test_reponse_is_not_valid
    refute journey(@raw_xml.gsub('<status>OK</status>', '<status>FAILED</status>')).valid?
  end

  def test_status
    assert_equal "OK", journey(@raw_xml).status
    assert_equal "FAILED", journey(@raw_xml.gsub('<status>OK</status>', '<status>FAILED</status>')).status
  end

  def test_finding_driving_distance_in_metres
    journey = journey(@raw_xml)
    assert_equal(357186, journey.distance.to_metres)
    assert_equal(35.7186, journey.distance.to_kilometres)
    assert_equal(221.9450, journey.distance.to_miles.round(4))
  end

  def test_finding_driving_duration_in_seconds
    journey = journey(@raw_xml)
    assert_equal(15179, journey.duration_in_seconds)
  end
end
