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

class AnswersController < ApplicationController
  def new
    @activation_code = ActivationCode.find_by_code(params['activation_code']['code'])
    redirect_to( bad_user_path ) && return        if @activation_code.nil?
    redirect_to( completed_poll_path ) && return  if @activation_code.poll_completed?

    @answer = @activation_code.next_answer
    @question = @answer.question
  end

  def create
    # check that User.find(params[:user][:sha]) == Answer.find(params[:id]).user
    @activation_code  = ActivationCode.find_by_code( params[:activation_code][:code] )
    @answer = Answer.find( params[:answer][:id] )
    raise "Trying to use an unassigned code" if !@activation_code.consumed
    
    redirect_to( bad_user_path ) && return if @activation_code.nil?
    redirect_to( bad_answer_path ) && return if @answer.activation_code.nil? || @activation_code != @answer.activation_code
    
    @answer.assign_alternative!(params[:alternative][:id])
    

    redirect_to :action => :new, :activation_code => { :code => @activation_code.code }
  end
end
