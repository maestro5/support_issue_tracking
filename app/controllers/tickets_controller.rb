class TicketsController < ApplicationController
  before_action :set_ticket, only: %i(show edit)

  def index
    if user_signed_in?
      @tickets = Ticket.unassigned
    end
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @service = TicketCreateService.(params: params)
    @ticket = @service.ticket
    if @service.success?
      redirect_to @ticket, notice: 'Your ticket has been successfully created!'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @service = TicketUpdateService.(user: current_user, params: params)
    @ticket = @service.ticket
    if @service.success?
      redirect_to @ticket, notice: 'Your ticket has been successfully updated!'
    else
      render :edit
    end
  end

private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

end
