class ApplicationService
  attr_reader :user, :errors

  def self.call(*args)
    new(*args).tap(&:perform)
  end

  def perform
    ActiveRecord::Base.transaction do
      return true if executing

      @errors[:service] << {transaction: ['uknown error']} if @errors.empty?
      raise ActiveRecord::Rollback
    end

    false
  end

  def success?
    @errors.empty?
  end

private
  def initialize(*_args)
    @errors = ErrorsService.new
  end

  def executing
    raise 'not implemented'
  end

end
