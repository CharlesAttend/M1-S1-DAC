ABOUT TINA :
------------

Tina (TIme petri Net Analyzer) is  a toolbox for the analysis of Petri
Nets and Time Petri Nets. The latest version of Tina may be downloaded
from the web page www.laas.fr/tina, tab Download.

At that time, the toolbox includes:

nd (NetDraw) : Time Petri net and Automata editor.
~~~~~~~~~~~~~~
Allows one to create a {Time} Petri nets, in textual or graphical form.
Interfaced with some of the following tools.

tina : construction of reachability graphs.
~~~~~~
Depending upon the  option retained, builds (references at  the end of
file):

The coverability graph of a Petri net, by the Karp and Miller technique.

The  markings reachability  graph of  a  Petri net  (untimed, or  with
timing information discarded).

The covering  step graph  of a Petri  net, according to  the technique
introduced in (6,7), preserving various properties.

The partial marking  graph of a Petri net  according to the persistent
sets method,  as well as  three experimental variants of  it combining
persistent sets and covering steps, described in (8).

Various  state space  abstractions for  Time Petri  nets  (state class
graphs),  following the  techniques introduced  in (1,2),  and further
refined  in (3,5).   Depending  on option  selected, the  construction
perserves markings, states, LTL  properties, or CTL* properties of the
concrete state space of the Time Petri net.

sift: Construction and checking of reachability graphs.
~~~~~
Sift is  a specialized version of  tina supporting in  addition on the
fly verification  of reachability  properties. If offers  less options
than  tina but  is  typically faster  and  requires considerably  less
space.

struct :  structural analysis of Petri nets.
~~~~~~~
Computes  generator sets  for  semi-flows or  flows  on places  and/or
transitions  of  a Petri  net.   Also  determines  the invariance  and
consistency properties.

path : path analysis of Time Petri nets.
~~~~~~
Given a  firable sequence of  transitions, this tool computes  all, or
one of, depending  on options, firing schedule that  has this sequence
as support.

selt : A State/Event LTL model checker.
~~~~~~
This tool checks a Kripke  transition system against S/E-LTL formulas,
interactively or in batch mode.   Produce counter examples reusable by
the nd  stepper. For converting  S/E-LTL formula into  Buchi automata,
selt  relies on  the spin  converter (bundled)  or on  Oddoux/Gastin's
ltl2ba (www.lsv.fr/~gastin/ltl2ba).

muse: A modal mu-calculus model checker.
~~~~~
Model  checks a  Kripke transition  systems against  modal mu-calculus
formula.  Muse computes the set of states obeying some formula. A path
to some  state can then be  computed using the pathto  and plan tools,
and that path replayed on the model using tool play or the nd stepper.

play: Stepper simulator.
~~~~~
Allows to simulate interactively and  step by step net descriptions in
all formats accepted  by tina.  Its capabilities are  similar to those
of the  nd stepper except that  play may also  simulate nets augmented
with data processing (in tina tts format).

pathto: Path finder.
~~~~~~~
A utility tool computing the path to some state in a  kripke transition system.

ndrio : conversion tool for nets.
~~~~~~~
A tool for  converting Petri nets and Time  Petri nets between various
formats, including tina formats .net, .ndr and .tpn, and .pnml.

ktzio : conversion tool for transition systems.
~~~~~~~
A  tool   for  converting  labelled  transition   systems  (or  Kripke
transition  systems) between various  formats, including  formats .ktz,
.aut, .bcg, .mec, and textual formats.

frac: Fiacre to tina tts compiler.
~~~~~
A companion  tool, not distributed  with the toolbox but  available at
the companion site "http://projects.laas.fr/fiacre".  Fiacre is a high
level description language for real time systems; frac compiles Fiacre
descriptions into Time Petri nets enriched with data processing (in tina
tts format) that can then be checked with the TINA tools.


INSTALLATION:
------------

Read file INSTALL  for installation notes, 
man pages in various formats are found in directory doc.

The Tina toolbox is property of LAAS-CNRS, 7, avenue du Colonel Roche,
31077, Toulouse.   For any comments, bug reports  or specific demands,
please contact the author at bernard.berthomieu@laas.fr.

The binary distributions  of the Tina toolbox may  be freely installed
and used.  The software is  distributed "as is", without warranties or
conditions of any kind.


REFERENCES : (please check www.laas.fr/tina, tab papers, for updates)
------------

(1) B.  Berthomieu, M. Menasche, An Enumerative Approach for Analyzing
    Time Petri Nets, IFIP Congress 1983, Paris, 1983.

(2) B.   Berthomieu,  M.   Diaz,  Modeling and  verification  of  time
    dependent  systems using  time Petri  nets.  IEEE  Transactions on
    Software Engineering, 17(3), 1991.

(3) B. Berthomieu, La méthode des Classes d'états pour l'Analyse des Réseaux
    Temporels - Mise en Oeuvre, Extension à la multi-sensibilisation.
    Modélisation des Systèmes Réactifs, MSR'2001, Hermes, 2001.

(4) B.  Berthomieu,  P.-O.  Ribet,  F.  Vernadat,  The  tool  TINA  --
    Construction  of Abstract  State Spaces  for Petri  Nets  and Time
    Petri Nets, International Journal of Production Research, Vol. 42,
    No 4, July 2004.

(5) B. Berthomieu, F. Vernadat, State class constructions for branching
    analysis of Time Petri nets, TACAS 2003. Springer Verlag LNCS 2619,
    2003.

(6) F. Vernadat, P. Azéma, F. Michel, Covering Step Graph, Application
    and Theory of Petri Nets 96, Springer Verlag LNCS 1091, 1996.

(7) F. Vernadat, F. Michel, Covering Step Graph Preserving Failure Semantics,
    Application and Theory of Petri Nets 97, Springer-Verlag LNCS 1248, 1997.

(8) P-O. Ribet, F. Vernadat, B. Berthomieu, On Combining the Persistent Set
    Method with the Covering Step Graph Method, FORTE 2002, Springer Verlag
    LNCS 2529, 2002.

(9) B.  Berthomieu,   P.-O.  Ribet,  F.  Vernadat,   L'outil  TINA  --
    Construction d'espaces d'états abstraits pour les réseaux de Petri
    et réseaux Temporels, Modélisation des Systèmes Réactifs, MSR'2003,
    Hermes, 2003.
