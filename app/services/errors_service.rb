class ErrorsService
  def errors
    @errors_storage.select { |_k, v| !v.empty? }
  end

  def full_messages
    @errors_storage.map { |k, v| v.map { |msg| "#{k.to_s.humanize} #{msg}"} }.flatten
  end

  def [](attribute)
    attribute = attribute.to_sym
    @errors_storage[attribute] ||= []

    @errors_storage[attribute]
  end

  def []=(attribute, messages)
    attribute = attribute.to_sym
    messages = Array(messages)
    @errors_storage[attribute] = messages
  end

  def empty?
    errors.empty?
  end

private
  
  def initialize
    @errors_storage = {}
  end

end