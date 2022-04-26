class Api::V1::EventsController < Api::V1::BaseController

  def index
    @events = Event.all
    render json: {
      events: @events
    }
  end
end
