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
  belongs_to :alternative
  belongs_to :question
  belongs_to :activation_code
  
  named_scope :filled_answers, :conditions => 'alternative_id is not NULL'
  named_scope :assignable_answers, :conditions => 'activation_code_id is NULL AND alternative_id is NULL'
  
  def assign_alternatives!(alternative_ids)
    # FIXME: Support more than one alternative!
    puts "Warn! Look at the FIXME"
    alternative_id = alternative_ids[0]
    
    Answer.transaction do
      self.activation_code = nil
      self.alternative_id = alternative_id
      self.save!    
    end
  end
  
  def Answer.stats
    alt_stats = {}
    Alternative.all.each do |a|
      alt_stats[a.question_id] ||= {}
      alt_stats[a.question_id][a.id] = Answer.count(:conditions => {:alternative_id => a.id})
    end
    
    alt_stats
  end
  
end
