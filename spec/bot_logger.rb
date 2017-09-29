class BotLogger
  LOGGER_METHODS = /(info|warn|error|fatal)/

  def respond_to_missing?(method, *)
    method.to_s =~ LOGGER_METHODS || super
  end

  def method_missing(method, *args)
    if respond_to?(method)
      puts args
    else
      super
    end
  end
end
