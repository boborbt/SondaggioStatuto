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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User acceptance depends on ApplicationConfig settings - regexp pattern case" do
    old_setting = APP_CONFIG['email_validation']
    APP_CONFIG['email_validation'] = /[@.]unito.it/
    
    u = User.new(:email => 'esposito@di.unito.it')
    assert u.valid?
    
    u2 = User.new(:email => 'boborbt@gmail.com')
    assert !u2.valid?
    
    APP_CONFIG['email_validation'] = old_setting
  end
  
  test "User acceptance depends on ApplicationConfig settings - white listed email case" do
    old_setting = APP_CONFIG['email_validation']
    APP_CONFIG['email_validation'] = 'white_list'
    AllowedEmail.create(:email => 'bobo@bobo.com')
    
    u = User.new(:email => 'bobo@bobo.com')
    assert u.valid?
    
    u2 = User.new(:email => 'not-allowed@di.unito.it')
    assert !u2.valid?

    APP_CONFIG['email_validation'] = old_setting
  end
  
end
