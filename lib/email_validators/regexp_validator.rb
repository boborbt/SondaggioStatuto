class RegexpValidator
  def initialize(regexp)
    @regexp = regexp
  end
  
  
  def validate_email(email)
    return @regexp.match(email)
  end
end

