class TicketsController < ApplicationController
  before_action :set_ticket, only: :show

  def index
    @ticket = Ticket.all
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

private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

end
