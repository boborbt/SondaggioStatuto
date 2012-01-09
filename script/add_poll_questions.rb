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
  	Quesito n.1: Composizione del Senato Accademico
  </div> 
  <p>Scegliere una delle due possibilit&agrave;</p>
}

q2text = %q{
  <div class="tit_quesito">
  Quesito n. 2: Composizione del Consiglio di Amministrazione
  </div>

  <p>Scegliere una delle due possibilit&agrave;</p>
}

q1alt1 = %q{
  <div class="alternativa_a">
  <p>A)  &ndash; Versione attuale dello statuto</p>
  <p>Compongono il Senato accademico</p>
  <ol type=a>
  	<li>il Rettore, che lo presiede;</li>
  	<li>ventiquattro docenti di ruolo, di cui almeno otto Direttori di Dipartimento, eletti da tutti i professori e i ricercatori dell&rsquo;Ateneo;</li>
  	<li>quattro rappresentanti del personale tecnico-amministrativo;</li>
  	<li>sei rappresentanti degli studenti eletti fra gli studenti iscritti ai Corsi di Laurea, Laurea Magistrale e Dottorato di Ricerca.</li>
  </ol>
  <p>I ventiquattro docenti di ruolo sono cos&igrave; suddivisi:</p>
  <p><strong>24 rappresentanti di area (di cui 8 direttori); ad ogni area viene assegnato un numero di rappresentanti definito da apposita tabella approvata dal senato</strong></p>
  </div>  <!-- end alternativa_a -->
}

q1alt2 = %q{
  <div class="alternativa_b">
  <p>B) – Versione alternativa dello statuto</p> 
  <p>Compongono il Senato accademico</p>
  <ol type=a>
  <li>il Rettore, che lo presiede;</li>
  <li>ventiquattro docenti o ricercatori, di cui almeno otto Direttori di Dipartimento, eletti da tutti i professori e i ricercatori dell&rsquo;Ateneo;</li>
  <li>quattro rappresentanti del personale tecnico-amministrativo;</li>
  <li>sei rappresentanti degli studenti eletti fra gli studenti iscritti ai Corsi di Laurea, Laurea Magistrale e Dottorato di Ricerca.</li>
  </ol>
  <p>I ventiquattro docenti di ruolo sono così suddivisi:</p>
  <p><strong>16 rappresentanti di area (di cui 8 direttori)
  8 docenti o ricercatori eletti da tutti i docenti e ricercatori dell'Ateneo.</strong></p>
  </div> <!-- end alternativa_b -->
}

q2alt1 = %q{
  <div class="alternativa_a">
  <p>A)  – Versione attuale dello statuto</p>

  <p>Il Consiglio di Amministrazione &egrave; costituito da undici componenti:</p>
  <ol type=a>
  	<li>il Rettore, che lo presiede;</li>
  	<li>due rappresentanti eletti dagli studenti;</li>
  	<li>tre componenti non appartenenti ai ruoli dell&rsquo;Ateneo, <strong>scelti dal Senato Accademico fra i candidati che partecipano ad un bando esterno</strong>;</li>
  	<li>cinque componenti appartenenti al personale di ruolo dell&rsquo;Ateneo: per questi il <strong>Senato Accademico</strong> procede ad individuare una rosa di candidati almeno doppia rispetto al numero dei componenti da designare, tra i candidati che partecipano ad un bando interno; successivamente, nell&rsquo;ambito di tale rosa, i componenti appartenenti al personale di ruolo dell&rsquo;Ateneo sono eletti dallo stesso corpo elettorale delle elezioni per il Rettore.</li>
  </ol>
  </div> <!-- end alternativa_a -->
}

q2alt2 = %q{
  <div class="alternativa_b">
  <p>B) – Versione alternativa dello statuto</p>

  <p>Il Consiglio di Amministrazione &egrave; costituito da undici componenti:</p>
  <ol type=a>
  	<li>il Rettore, che lo presiede;</li>
  	<li>due rappresentanti eletti dagli studenti;</li>
  	<li>tre componenti non appartenenti ai ruoli dell&rsquo;Ateneo, <strong>scelti dalla Commissione Paritetica per il CdA fra i candidati che partecipano ad un bando esterno</strong>;</li>
  	<li>cinque componenti appartenenti al personale di ruolo dell&rsquo;Ateneo: per 
  questi <strong>la Commissione Paritetica per il CdA</strong> procede ad individuare una rosa di candidati almeno doppia rispetto al numero dei componenti da designare, tra i candidati che partecipano ad un bando interno; successivamente, nell&rsquo;ambito di tale rosa, i componenti appartenenti al personale di ruolo dell&rsquo;Ateneo sono eletti dallo stesso corpo elettorale delle elezioni per il Rettore.
  		<p><strong>La Commissione Paritetica per il CdA &egrave; costituita da:</strong></p>
  		<ul>
  			<li><strong>3 professori ordinari</strong></li>
  			<li><strong>3 professori associati</strong></li>
  			<li><strong>3 ricercatori (a tempo determinato o indeterminato)</strong></li>
  			<li><strong>3 tecnici amministrativi</strong></li>
  			<li><strong>3 assegnisti di ricerca (o borsisti, o co.co.co., etc.)</strong></li>
  			<li><strong>3 studenti</strong></li>
  		</ul>
  		<p><strong>Ogni componente elegge i suoi rappresentanti nella commissione paritetica con le modalit&agrave; definite da apposito regolamento.</strong></p>
  	</li>
  </ol>
  </div> <!-- end alternativa_b -->
}

q1 = Question.create!( :text => q1text, :sort_id => 1 )
q1.alternatives << Alternative.create!( :text => q1alt1 )
q1.alternatives << Alternative.create!( :text => q1alt2 )

q2 = Question.create!( :text => q2text, :sort_id => 2 )
q2.alternatives << Alternative.create!( :text => q2alt1 )
q2.alternatives << Alternative.create!( :text => q2alt2 )

