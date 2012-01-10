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

require 'sha1'

class User < ActiveRecord::Base
  has_one :activation_code
    
  validates_uniqueness_of :email  
  
  def validate
    unless ApplicationConfig.valid_email?(self.email)    
      errors.add_to_base("L'email address #{self.email} non è ritenuto valido per questo sondaggio")
    end
  end
  
  def assign_activation_code!
    self.activation_code = ActivationCode.consume_one!
    self.save!
  end
  
  def has_voted?
    !activation_code.blank? && activation_code.answers.blank?
  end
  
  def User.stats
    users_ids = ActivationCode.all( :conditions => { :consumed => true } ).map { |a| a.user_id }
    users = User.all( :conditions => { :id =>  users_ids})
    users.reject! { |u| !u.has_voted? }
    result = { }
    users.each do |u|
      u.email =~ /@(.*unito.it)/
      result[$1] ||= 0
      result[$1] += 1
    end
    
    result  
  end
end
