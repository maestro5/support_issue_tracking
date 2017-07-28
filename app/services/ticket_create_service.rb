class TicketCreateService < ApplicationService
    attr_reader :ticket

    def initialize(params:)
      @params = params
      super
    end

  private
    def executing
      create_ticket && send_notification_letter
    end

    def create_ticket
      @ticket = Ticket.create(ticket_params)
      @errors[:ticket] = @ticket.errors.messages
      @ticket.persisted?
    end

    def ticket_params
      @params
        .require(:ticket)
        .permit(
          :name, :email, :department_id, :subject,
          :ticket_status_id, :question, :user_id,
          messages: [:message, :user_id]
        )
        .merge(default_attrs)
    end

    def default_attrs
      {
        ticket_status_id: TicketStatus.default.id,
        reference_number: generate_reference_number
      }
    end

    def generate_reference_number
      reference_number = ''
      begin
        reference_number = 
        "#{random_char_string}-#{random_hex_numbers}-" +
        "#{random_char_string}-#{random_hex_numbers}-" +
        "#{random_char_string}"
      end while Ticket.exists?(reference_number)
      reference_number
    end

    def random_char_string
      ('A'..'Z').to_a.sample(3).join
    end

    def random_hex_numbers
      SecureRandom.hex(1).upcase
    end

    def send_notification_letter
      message = 'Your request has been received.'
      TicketMailer.ticket_notification(@ticket, message).deliver_now
    end
      
end
