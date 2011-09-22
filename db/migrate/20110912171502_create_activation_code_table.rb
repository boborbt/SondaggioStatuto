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

class CreateActivationCodeTable < ActiveRecord::Migration
  def self.up
    create_table :activation_codes, :force => true do |t|
      t.integer :user_id
      t.string :code
      t.boolean :consumed
    end
    
    add_index :activation_codes, :code
    add_index :activation_codes, :consumed
    add_index :activation_codes, :user_id
  end

  def self.down
    remove_index :activation_codes, :user_id
    remove_index :activation_codes, :active
    remove_index :activation_codes, :code
    drop_table :activation_code
  end
end
