class DomainValidator
  def validate_email(email)
    domain = domain_of(email)
    AllowedDomain.find_by_domain(domain)
  end
  
  private
  def domain_of(email)
    match = /@(.*)$/.match(email)
    match[1]
  end
end