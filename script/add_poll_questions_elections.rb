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


q1text = %q{
  <div class="tit_quesito">
  Selezionare il candidato prescelto:
  </div> 
}

q1alt1 = %q{
  <div class="alternativa">
  <p>A)  &ndash; Bobo</p>
  </div>
}

q1alt2 = %q{
  <div class="alternativa">
  <p>B)  &ndash; Bobo</p>
  </div>  
}

q1alt3 = %q{
  <div class="alternativa">
  <p>C)  &ndash; Leo</p>
  </div>
}

q1alt4 = %q{
  <div class="alternativa">
  <p>D)  &ndash; Gigi</p>
  </div>  
}

q1 = Question.create!( :text => q1text, :sort_id => 1 )
q1.alternatives << Alternative.create!( :text => q1alt1 )
q1.alternatives << Alternative.create!( :text => q1alt2 )
q1.alternatives << Alternative.create!( :text => q1alt3 )
q1.alternatives << Alternative.create!( :text => q1alt4 )


