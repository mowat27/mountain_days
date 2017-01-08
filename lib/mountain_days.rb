require 'exif'
require 'csv'
require 'haversine'
require 'bigdecimal'

module MountainDays
  def load_peaks(ifile)
    csv = CSV.read(ifile, encoding: "ISO8859-1")
    headers, rows = csv.shift.map {|hdr| hdr.strip}, csv

    peaks = rows.reduce([]) do |res, row|
      res << Hash[headers.zip(row)]
    end
  end

  def distances_from_lat_long(peaks, lat_long)
    peaks.reduce([]) do |arr, peak|
      peak_loc = [peak["latitude"], peak["longitude"]].map(&:to_f)
      arr << peak.merge(
        "from_lat_long" => lat_long,
        "to_lat_long" => peak_loc,
        "distance" => Haversine.distance(lat_long, peak_loc)
      )
    end
  end

  def load_and_validate_image(img)
    exif = Exif::Data.new(img)
    return nil if !exif[:gps_latitude] || !exif[:gps_longitude]
    exif
  end
end
