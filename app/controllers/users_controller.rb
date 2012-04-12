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


class UsersController < ApplicationController
  before_filter :check_if_closed, :except => [:check, :bad]

  # new / GET
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      @user.assign_activation_code!
    
      @activation_code = @user.activation_code    
      (redirect_to(depleted_codes_path); return) if @user.activation_code.nil?
      
      UserCheck.deliver_activation_code(@user) unless ApplicationConfig.no_mail_sending?
      redirect_to(check_user_path)
    else
      render :action => "new"
    end
  end
  
  def check_if_closed
    redirect_to closed_votes_path if ApplicationConfig.state == :closed
  end
end
