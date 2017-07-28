class TicketsController < ApplicationController
  before_action :set_ticket, only: %i(show edit update)
  before_action :edit_allowed?, only: %i(edit update)

  def index
    if user_signed_in?
      @tickets = Ticket.manager_search(params[:search]).unassigned
    else
      @tickets = Ticket.customer_search(params[:search]) if params[:search]
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

  def edit_allowed?
    unless policy.allowed?
      redirect_to root_path, notice: 'The reference number for the ticket does not match!'
    end
  end

  def policy
    UpdateTicketPolicy.new(current_user, @ticket, params[:ref_number])
  end

end
