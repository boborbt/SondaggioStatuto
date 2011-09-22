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
# along with CFactorGraphs.  If not, see <http://www.gnu.org/licenses/>.

class UserCheck < ActionMailer::Base
  

  def activation_code(user, sent_at = Time.now)
    subject    %q{Credenziali di accesso al sondaggio sullo Statuto dell'Università di Torino}
    recipients user.email
    from       'sondaggio.statuto@gmail.com'
    sent_on    sent_at
    
    body      :activation_code => user.activation_code.code
  end

end
