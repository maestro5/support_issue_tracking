class UpdateTicketPolicy
  def initialize(current_user, ticket, ref_number)
    @current_user = current_user
    @ticket = ticket
    @ref_number = ref_number
  end

  def allowed?
    return true if @current_user && (@current_user.super_admin? || @current_user.manager?)
    @ticket.reference_number == @ref_number
  end
end
