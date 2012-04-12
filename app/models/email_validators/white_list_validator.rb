class WhiteListValidator < ActiveRecord::Base
  def validate_email(email)
    return AllowedEmail.find_by_email(email)
  end
end
