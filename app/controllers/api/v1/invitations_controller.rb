# app/controllers/api/v1/invitations_controller.rb

class Api::V1::InvitationsController < ApplicationController
  def create
    # Make sure the file was actually sent.
    file = params[:customers_file]
    return render_error('File not provided.', :bad_request) unless file

    # Let the service do the heavy lifting.
    invitees = CustomerInvitationService.new(file).call
    render json: invitees, status: :ok
  
  # A general rescue for anything unexpected that the service doesn't handle.
  rescue => e
    Rails.logger.error "Invitation processing failed: #{e.message}"
    render_error('Failed to process file.', :internal_server_error)
  end

  private

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
