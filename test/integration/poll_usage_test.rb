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
require 'capybara/rails'

class PollUsageTest < ActionController::IntegrationTest
  include Capybara::DSL

  def setup
    ApplicationConfig.state = :open

    @q1 = Question.create( :text => 'q1', :sort_id => 1, :num_choices => 1)
    @q1.alternatives << Alternative.new( :text => 'q1 a1' )
    @q1.alternatives << Alternative.new( :text => 'q1 a2' )
    
    @q2 = Question.create( :text => 'q2', :sort_id => 2, :num_choices => 1)
    @q2.alternatives << Alternative.new( :text => 'q2 a1' )
    @q2.alternatives << Alternative.new( :text => 'q2 a2' )        

    10.times do
      a = ActivationCode.new(:consumed => false)
      a.generate_sha!
      a.generate_answers!
      a.save!      
    end
  end
  
  test "Regexp based email checking" do
    old_config = APP_CONFIG['email_validation']
    APP_CONFIG['email_validation'] = /@di.unito.it$/
    
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@di.unito.it')
    click_on('Continua')    
    
    assert page.has_content?('codice utente')
    
    APP_CONFIG['email_validation'] = old_config
  end
  
  test "WhiteList based email checking" do
    old_config = APP_CONFIG['email_validation']
    APP_CONFIG['email_validation'] = 'white_list'
    AllowedEmail.create(:email => 'bobo@bobo.com')
    
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'bobo@bobo.com')
    click_on('Continua')    
    
    assert page.has_content?('codice utente')
    
    APP_CONFIG['email_validation'] = old_config
  end
  
  
  test "Complete user flow from email giving to completing the poll" do    
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@di.unito.it')
    click_on('Continua')    

    assert page.has_content?('codice utente')
    
    u = User.all
    assert_equal 1, u.size
    fill_in('codice utente', :with => u[0].activation_code.code)
    click_on('Continua')
    
    assert page.has_content?('q1')
    assert page.has_content?('q1 a1')
    assert page.has_content?('q1 a2')
    assert !page.has_content?('q2')
    check('q1 a1')
    click_on('Confermo')
    
    assert page.has_content?('q2')
    assert page.has_content?('q2 a1')
    assert page.has_content?('q2 a2')
    assert !page.has_content?('q1')  
    check('q2 a2')
    click_on('Confermo')
    
    assert_equal @q1.filled_answers[0].choices, [Alternative.find_by_text('q1 a1').id]
    assert_equal @q2.filled_answers[0].choices, [Alternative.find_by_text('q2 a2').id]

    
    assert page.has_content?('Sondaggio completato')    
  end
  
  test "Inserting an non-unito email address results in an error" do
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@no-unito-email.it')
    click_on('Continua')
    
    assert page.has_css?('#errorExplanation')
  end
  
  test "Inserting an already taken email results in an error" do
    assert_equal 0, User.count
    
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@unito.it')
    click_on('Continua')

    assert page.has_content?('codice utente')
    
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@unito.it')    
    click_on('Continua')
    
    assert page.has_css?('#errorExplanation')    
  end
  
  test "check page refuses unknown codes" do
    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@di.unito.it')    
    click_on('Continua')

    fill_in('codice utente', :with => '----------invalid-sha1------------------')
    click_on('Continua')
    
    assert page.has_content?('Controllo utente fallito')
  end
  
  test "trying to connect directly to the new answer page works only if a valid sha1 is provided" do
    # Just to be sure that some user does exist
    assert_equal 2, Question.count

    visit( root_path )
    click_on('Partecipa')
    fill_in('Email', :with => 'esposito@unito.it')    
    click_on('Continua')
    
    visit( new_answer_path(:activation_code => {:code => 'rubbish'} ) )
    assert page.has_content?('Controllo utente fallito')
  end
  
  test "statistics works" do
    select_alternatives([0,0])
    select_alternatives([1,0])
    select_alternatives([0,1])
    select_alternatives([1,0])

    assert_equal 2,Answer.stats[@q1.id][@q1.alternatives[0].id]
    assert_equal 2,Answer.stats[@q1.id][@q1.alternatives[1].id]
    assert_equal 3,Answer.stats[@q2.id][@q2.alternatives[0].id]
    assert_equal 1,Answer.stats[@q2.id][@q2.alternatives[1].id]
  end

  test 'A closed site should block new users from registering' do
    ApplicationConfig.state = :closed
    visit( root_path )
    click_on( 'Partecipa' )

    assert page.has_css?('p.warning')

    post( users_path )
    assert page.has_css?('p.warning')
  end

  test 'A down site should block everything except the site_down page' do
    ApplicationConfig.state = :down
    
    check_if_down(root_path)
    check_if_down(users_path, :post)
    check_if_down(new_user_path)
    check_if_down(answers_path, :post)
    check_if_down(new_answer_path)
    check_if_down(check_user_path)
    check_if_down(bad_user_path)
    check_if_down(completed_poll_path)
    check_if_down(depleted_codes_path)
    check_if_down(bad_answer_path)
    check_if_down(closed_votes_path)
  end
  
  
  private
  def select_alternatives(choices)
    visit( root_path )
    click_on('Partecipa')
    
    user = rand(100).to_s
    email = "#{user}@di.unito.it"
    fill_in('Email', :with => email)
    click_on('Continua')
        
    u = User.find_by_email(email)
    fill_in('codice utente', :with => u.activation_code.code)
    click_on('Continua')
    
    check("selected_alternatives[#{@q1.alternatives[choices[0]].id}]")
    click_on('Confermo')
    
    check("selected_alternatives[#{@q2.alternatives[choices[1]].id}]")
    click_on('Confermo')
  end

  def check_if_down path, method=:get
    if method==:post 
      post( path )
    else
      visit( path )
    end

    assert page.has_css?('p.warning')
  end
end
