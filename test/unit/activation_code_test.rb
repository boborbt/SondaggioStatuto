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

require 'test_helper'

class ActivationCodeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "#generate_answers should generate one answer for each question and they are in the correct order" do
    Question.create( :text => 'q1', :sort_id => 1)
    Question.create( :text => 'q2', :sort_id => 2)
    
    ac = ActivationCode.new
    assert_equal 0, ac.answers.size
    
    ac.generate_answers!
    ac.generate_sha!
    ac.associate_answers!    

    assert_equal 2, ac.answers.size, "Got: #{ac.answers.map { |a| a.id }.join(',')}"
    assert_equal 1, ac.answers[0].question.sort_id, "got question #{ac.answers[0].question.text}"
    assert_equal 2, ac.answers[1].question.sort_id, "got question #{ac.answers[1].question.text}"
  end
  
  test '#completed_questionary? should return false if any of the answers is blank' do
    Question.create( :text => 'q1', :sort_id => 1)
    Question.create( :text => 'q2', :sort_id => 2)

    ac = ActivationCode.new
    ac.generate_sha!
    ac.generate_answers!
    ac.associate_answers!
    
    assert !ac.poll_completed?    
  end

  test '#completed_questionary? should return true if all of answers are non-blank' do
    Question.create( :text => 'q1', :sort_id => 1)
    Question.create( :text => 'q2', :sort_id => 2)

    ac = ActivationCode.new
    ac.generate_answers!
    ac.generate_sha!
    ac.associate_answers!
    
    ac.answers[0].alternative_id = 0
    ac.answers[1].alternative_id = 0
    
    assert ac.poll_completed?    
  end

  test 'ApplicationConfig#next_answer should return the first non-blank answer in question.sort_id order' do
    Question.create( :text => 'q1', :sort_id => 2)
    Question.create( :text => 'q2', :sort_id => 1)

    ac = ActivationCode.new
    ac.generate_sha!
    ac.generate_answers!
    ac.associate_answers!
    ac.save!
    
    ac = ActivationCode.first
    
    assert_equal 1, ac.next_answer.question.sort_id
    
    next_answer = ac.next_answer
    assert_equal 1, next_answer.question.sort_id # should still the number 1, since we did not completed it yet

    next_answer.assign_alternative!(2)
    next_answer.save!
    
    ac.reload
    assert_equal 2, ac.next_answer.question.sort_id
  end


  test "consume_one should return one of the available codes and make it invalid" do
    srand(1893)
    a1 = ActivationCode.new( :consumed => false )
    a2 = ActivationCode.new( :consumed => false )
    a3 = ActivationCode.new( :consumed => false )

    a1.generate_sha!
    a2.generate_sha!
    a3.generate_sha!
    
    a1.save!
    a2.save!
    a3.save!
    
    codes = [a1,a2,a3]
    consumed = []
    
    3.times do 
      c = ActivationCode.consume_one!
      assert codes.include?( c )
      codes -= [c]
      consumed << c
    end
    
    assert_not_equal consumed, [a1,a2,a3]
    
    assert_equal 0, ActivationCode.not_consumed.size
  end
  
  test "associate_answers! should associate one answer for each question and make them unavailable to others" do
    Question.create( :text => 'q1', :sort_id => 2)
    Question.create( :text => 'q2', :sort_id => 1)
    ac = ActivationCode.new( :consumed => false )
        
    ac.generate_answers!
    ac.generate_sha!
    ac.save!
    
    assert_equal 2, Answer.assignable_answers.count
    ac.associate_answers!
    
    assert_equal 2, ac.answers.count    
    assert_equal 0, Answer.assignable_answers.count    
  end
end
