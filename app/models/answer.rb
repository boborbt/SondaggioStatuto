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

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :activation_code
  
  named_scope :filled_answers, :conditions => 'choices is not NULL'
  named_scope :assignable_answers, :conditions => 'activation_code_id is NULL AND choices is NULL'
  
  def validate
    unless choices.nil? || choices.size <= question.num_choices
      errors.add_to_base("Il numero di scelte (attualmente #{choices.size}) deve essere minore o uguale a #{question.num_choices}")
    end
  end
  
  def choices
    self['choices'] && self['choices'].split(',').map { |c| c.to_i } || nil
  end
  
  def choices= values
    self['choices'] = (values.nil? ? nil : values.join(','))
  end
  
  def assign_choices(alternative_ids)    
    result = nil
    Answer.transaction do
      self.activation_code = nil
      self.choices = alternative_ids
      result = self.save
      raise ActiveRecord::Rollback unless result
    end
    
    result
  end
  
  def Answer.stats
    alt_stats = {}
    valid_answers = Answer.all(:conditions => 'choices IS NOT NULL')
    Alternative.all.each do |alt|
      alt_stats[alt.question_id] ||= {}      
      alt_stats[alt.question_id][alt.id] = valid_answers.find_all { |answer| answer.choices.include?(alt.id) }.count
    end
    
    alt_stats
  end
  
end
