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

questions = []

questions << {
  :text => %q{<h1>Commissione Regolamenti Organi Centrali</h1><p>Da questa consultazione emergeranno i nominativi di due ricercatori che prenderanno parte ai lavori della Commissione Modifiche Statuto in merito alla stesura dei regolamenti per gli organi centrali.</p>},
  :alts => [  %q{Guido Bonino}, 
              %q{Anna Miglietta}, 
              %q{Silvia Pasqua} ]
}

questions << {
  :text => %q{<h1>Commissione Organi Decentrati</h1><p>Da questa consultazione emergeranno i nominativi di due ricercatori che prenderanno parte ai lavori della Commissione Modifiche Statuto in merito alla stesura dei regolamenti per gli organi decentrati.</p>},
  :alts => [  %q{Alessandro Barge},
              %q{Silvia Gattino},
              %q{Giuseppe Noto},
              %q{Giovanni Semi} ]
}

questions << {
  :text => %q{<h1>Commissione Regolamenti Elettorali</h1><p>Da questa consultazione emergeranno i nominativi di due ricercatori che prenderanno parte ai lavori della Commissione Modifiche Statuto in merito alla stesura dei regolamenti elettorali.</p>},
  :alts => [  %q{Angelo Besana},
              %q{Lia Pacelli},
              %q{Marco Scavino} ]
}

questions.each_with_index do |q_info, i|
  q = Question.create!( :text => q_info[:text], :sort_id => i+1, :num_choices => 2 )
  q_info[:alts].each do |alternative|
    q.alternatives << Alternative.create!(:text => alternative)
  end
end

