class TicketUpdateService < ApplicationService
  attr_reader :ticket

  def initialize(user:, params:)
    @user   = user
    @params = params
    super
  end

  private
    def executing
      find_ticket && update_ticket && track_ticket_changes && create_message && send_notification_letter
    end

    def find_ticket
      @ticket = Ticket.find(@params[:id])
      @ticket.persisted?
    end

    def update_ticket
      @ticket.assign_attributes(ticket_params)
      @ticket_changes = get_ticket_changes
      @ticket.save
      @errors[:ticket] = @ticket.errors.messages
      @ticket.persisted?
    end

    def track_ticket_changes
      return true if @user.nil?  #customer
      @ticket_changes.each do |change|
        changed_attribute = change.gsub('_id', '')
        @ticket
          .ticket_changes
          .create(changeable: @ticket.send(changed_attribute))
      end
      true
    end

    def create_message
      @message = @ticket.messages.create(message_params)
      return true if @user  #manager

      @errors[:message] = @message.errors.messages
      return true if @message.persisted? && set_default_status  #customer
      false
    end

    def send_notification_letter
      return true if @user && !@message.persisted?
      message = 'You have a new response to your question.'
      TicketMailer.ticket_notification(@ticket, message).deliver_now
    end

    def get_ticket_changes
      @ticket.changed & %w(user_id ticket_status_id)      
    end

    def ticket_params
      @params.require(:ticket).permit(:user_id, :ticket_status_id)
    end

    def message_params
      @params[:ticket].require(:messages).permit(:body, :user_id)
    end

    def set_default_status
      @ticket.update_attribute(:ticket_status_id, TicketStatus.default.id)
    end

end
