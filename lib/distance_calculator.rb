# lib/distance_calculator.rb

# This module provides a utility for calculating the great-circle distance
# between two GPS coordinates using the spherical law of cosines.
module DistanceCalculator
  # Earth's radius in kilometers.
  EARTH_RADIUS_KM = 6371.0

  # GPS coordinates for the Mumbai office.
  MUMBAI_OFFICE_LAT = 19.0590317
  MUMBAI_OFFICE_LON = 72.7553452

  # Calculates the distance between two points on Earth.
  # @param lat1 [Float] Latitude of the first point in degrees.
  # @param lon1 [Float] Longitude of the first point in degrees.
  # @param lat2 [Float] Latitude of the second point in degrees.
  # @param lon2 [Float] Longitude of the second point in degrees.
  # @return [Float] The distance in kilometers.
  def self.calculate(lat1, lon1, lat2, lon2)
    # Convert degrees to radians for trigonometric functions
    lat1_rad = to_radians(lat1)
    lon1_rad = to_radians(lon1)
    lat2_rad = to_radians(lat2)
    lon2_rad = to_radians(lon2)

    # Spherical Law of Cosines formula
    # Δσ = arccos(sin(φ₁)sin(φ₂) + cos(φ₁)cos(φ₂)cos(Δλ))
    # d = r * Δσ
    delta_longitude = lon2_rad - lon1_rad

    central_angle = Math.acos(
      Math.sin(lat1_rad) * Math.sin(lat2_rad) +
      Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.cos(delta_longitude)
    )

    EARTH_RADIUS_KM * central_angle
  end

  private

  # Helper method to convert degrees to radians.
  # @param degrees [Float]
  # @return [Float]
  def self.to_radians(degrees)
    degrees * Math::PI / 180.0
  end
end
