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

class AnswerTest < ActiveSupport::TestCase
  def setup
    @alt1 =  Alternative.create
    @alt2 =  Alternative.create
    @alt3 =  Alternative.create
    @alt4 =  Alternative.create

    @q = Question.create!( :sort_id => 1, :num_choices => 2 )
    @a = Answer.create!(:question => @q)
  end
  
  test "assign choices should store the given vector of alternative ids" do
    @a.choices = [@alt1.id, @alt3.id]
    @a.save!    
    
    assert_equal @a.choices, [@alt1.id, @alt3.id]    
  end
  
  test "assign choices should support abstined votes" do
    assert @a.choices.nil?
    
    @a.choices = []
    @a.save!
    
    assert_equal @a.choices, []
  end
end
