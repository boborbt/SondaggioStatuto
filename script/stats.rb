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

stats = Answer.stats
puts "Numero votanti: #{stats[1][1]+stats[1][2]}"

puts %Q{
  Quesito 1:
	alternativa 1: #{stats[1][1]}
	alternativa 2: #{stats[1][2]}
  Quesito 2:
	alternativa 1: #{stats[2][3]}
	alternativa 2: #{stats[2][4]}
}
