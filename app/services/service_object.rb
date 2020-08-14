class ServiceObject
  def initialize(options)
    options = options.with_indifferent_access
    initialize_attributes(options)
  end

  def self.execute(options = {})
    return new(options).execute
  end

  def execute
    raise NotImplementedError
  end

  private

  def initialize_attributes(options)
  end
end