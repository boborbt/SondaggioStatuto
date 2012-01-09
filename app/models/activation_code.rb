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

class ActivationCode < ActiveRecord::Base
  validates_presence_of :code
  belongs_to :user
  has_many :answers

  named_scope :not_consumed, :conditions => { :consumed => false }
    
  def generate_sha!
    self.code = SHA1.new( rand(100000).to_s + ApplicationConfig.secret + Time.now.usec.to_s).to_s
  end
  
  def generate_answers!
    questions = Question.all(:order => 'sort_id')
    questions.each do |q|
      # do create the answers, but do not associate it with the activation code
      # yet (this will be done at random at a later stage)
      Answer.create( :question => q )
    end
  end
  
  def associate_answers!    
    questions = Question.all(:order => 'sort_id')
    ActivationCode.transaction do
      questions.each do |q|
        # finds a randomly chosen answer for the current question
        free_count = Answer.assignable_answers.count( :conditions => { :question_id => q } )
        next_to_be_assigned = rand( free_count )
        assigned_answer = Answer.assignable_answers.find(:first, 
                                                         :conditions => { :question_id => q }, 
                                                         :offset => next_to_be_assigned, 
                                                         :limit => 1)
                                                  
        raise "Cannot find a free answer" unless assigned_answer # rollback the transaction if no one is found
      
        answers << assigned_answer # assigns the answer to the ActivationCode
      end
      save!
    end
  end
  
  def poll_completed?
    answers.all? { |a| !a.alternative_id.blank? }
  end
  
  def next_answer
    sorted_answers = answers.sort { |a1,a2| a1.question.sort_id <=> a2.question.sort_id}
    sorted_answers.first
  end
  
  def ActivationCode.consume_one!
    code = nil
    ActivationCode.transaction do
      free_count = ActivationCode.not_consumed.count

      next_to_be_consumed = rand( free_count )
      code = ActivationCode.not_consumed.find( :first, :offset => next_to_be_consumed, :limit => 1)
      return nil if code.nil?
    
      code.consumed = true
      
      code.associate_answers!
      code.save!
    end
    
    code
  end
  
end