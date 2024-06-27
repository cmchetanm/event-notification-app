class EventsController < ApplicationController
  before_action :authenticate!

  def index
    @events = iterable_service.get_user_events
  end

  def create
    event_type = params[:event_type]
    result = iterable_service.create_user_event(event_type)

    if event_type == 'EventB'
      iterable_service.send_email_notification
    end

    notice_message = "#{event_type} created successfully."
    notice_message += " Email sent." if event_type == 'EventB'

    redirect_to root_path, notice: notice_message
  end

  private

  def iterable_service
    @iterable_service ||= IterableService.new(current_user.id)
  end
end
