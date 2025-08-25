# app/services/customer_invitation_service.rb

# Processes the customer file to find people to invite.
class CustomerInvitationService
  MAX_DIST = 100.0

  def initialize(file)
    @file = file
  end

  def call
    # Read the file, process each line, and filter out anyone too far away.
    invitees = @file.read.each_line.filter_map do |line|
      customer = parse(line)
      # **FIX:** Skip if the line is bad json or missing essential data, including user_id.
      next unless customer && customer['latitude'] && customer['longitude'] && customer['user_id']

      dist = distance_from_office(customer)

      # If they're close enough, create an invite hash.
      { user_id: customer['user_id'], name: customer['name'] } if dist <= MAX_DIST
    end

    # Sort by user_id before returning.
    invitees.sort_by { |c| c[:user_id] }
  end

  private

  # Tries to parse a line of JSON. Returns nil if it fails.
  def parse(line)
    JSON.parse(line)
  rescue JSON::ParserError
    Rails.logger.warn "Skipping invalid JSON: #{line.strip}"
    nil
  end

  # Calculates distance from the office for a customer.
  def distance_from_office(customer)
    lat = customer['latitude'].to_f
    lon = customer['longitude'].to_f
    
    DistanceCalculator.calculate(DistanceCalculator::OFFICE_LAT, DistanceCalculator::OFFICE_LON, lat, lon)
  end
end
