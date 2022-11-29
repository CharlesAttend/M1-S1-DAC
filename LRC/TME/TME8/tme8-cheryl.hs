module TME7cheryl

where
import Data.List
import DEMO_S5

-- correction sur la base de celle de Malvin Gattinger
-- les agents sont a,b
-- les mondes possibles sont des couples (Int,String) pour jour et annee


-- la structure de Kripke de base

allDays = [ (15,"May"), (16,"May"), (19,"May"), (17,"June"), (18,"June"),(14,"July"), (16,"July"), (14,"August"), (15,"August"), (17,"August") ]
-- a connait le mois d'anniversaire
rela = (a,[[(15,"May"),(16,"May"),(19,"May")],[(17,"June"), (18,"June")],[(14,"July"), (16,"July")],[(14,"August"), (15,"August"), (17,"August")]])
-- b connait le jour d'anniversaire
relb = (b,[[(14,"July"),(14,"August")],[(15,"May"),(15,"August")],[(16,"May"),(16,"July")],[(17,"June"),(17,"August")],[(18,"June")],[(19,"May")]])
rels = [rela,relb]


-- creation de la structure

model0 :: EpistM (Int,String)
model0 = Mo allDays [a,b] [] rels []


-- connaitre la date: disjonction sur les dates possibles
knWhich :: Agent -> Form (Int, [Char])
knWhich i = Disj [ Kn i (Info s) | s <- allDays ]



