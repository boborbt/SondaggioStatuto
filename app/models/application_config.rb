# (c) Copyright 2011 Roberto Esposito (esposito@di.unito.it). All Rights Reserved.
#
# SondaggioStatuto is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# SondaggioStatuto is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with SondaggioStatuto.  If not, see <http://www.gnu.org/licenses/>.

class ApplicationConfig
  def ApplicationConfig.valid_states
 	[
	 :open, 			# accepting new people
	 :closed,			# not accepting people any more
	 :down				# site is down (only displays a closed-site page)
	]
  end
  
  def ApplicationConfig.poll_title
    APP_CONFIG['poll_title']
  end

  def ApplicationConfig.poll_description
    APP_CONFIG['poll_description']
  end

  def ApplicationConfig.check!        
    raise "Invalid application state:#{current}" unless valid_states.include?(@current)
  end
  
  def ApplicationConfig.valid_email?(email)
    validation = APP_CONFIG['email_validation']
    return validation.match(email) if validation.class == Regexp
    return AllowedEmail.find_by_email(email) if validation == 'white_list'
    
    raise "Unknown email validation method"
  end

  def ApplicationConfig.state
    return @current unless @current.nil?

    @current = APP_CONFIG['app_state'].to_sym
    check!

    @current
  end

  def ApplicationConfig.secret
    APP_CONFIG['secret']
  end

  def ApplicationConfig.state= new_state
    @current = new_state
    check!

    @current
  end

  def ApplicationConfig.no_mail_sending?
    APP_CONFIG['no_mail_sending'] == true
  end

  def ApplicationConfig.down?
    self.state == :down
  end

  def ApplicationConfig.closed?
    self.state == :closed?
  end

  def ApplicationConfig.open?
    self.state == :open
  end
end