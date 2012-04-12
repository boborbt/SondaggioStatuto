class DomainValidator
  def validate_email(email)
    domain = domain_of(email)
    return false if domain.nil?
    AllowedDomain.find_by_domain(domain)
  end
  
  private
  def domain_of(email)
    match = /@(.*)$/.match(email)
    match && match[1]
  end
end