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

  def distances(peaks, exif)
    img_loc = [exif[:gps_latitude], exif[:gps_longitude] * -1]

    peaks.reduce([]) do |arr, peak|
      peak_loc = [peak["latitude"], peak["longitude"]].map(&:to_f)
      arr << {
        "hillname" => peak["hillname"],
        "hill_lat_long" => peak_loc,
        "image_lat_long" => img_loc,
        "distance" => Haversine.distance(img_loc, peak_loc),
        "hill" => peak,
        "exif" => exif
      }
    end
  end

  def load_and_validate_image(img)
    exif = Exif::Data.new(img)
    return nil if !exif[:gps_latitude] || !exif[:gps_longitude]
    exif
  end
end
